#!/usr/bin/env node
// Usage: node bin/codex-model-resolve.mjs <codex-executable> <cwd> [effort]
// Resolve an unpinned pane worker using the selected Codex installation's
// model/list recommendation, not its user-configured model or name ordering.
// Reads config and catalog only; never starts a thread or submits a prompt.
// Prints JSON {model, provider, inheritedModel, effort} or refuses discovery.
// The runtime may cache its catalog; this is not a paid entitlement probe.
import { spawn } from "node:child_process";
import { createInterface } from "node:readline";

const [binary, cwd, requestedEffort = ""] = process.argv.slice(2);
if (!binary || !cwd) {
  console.error("usage: codex-model-resolve.mjs <codex-executable> <cwd> [effort]");
  process.exit(2);
}
const child = spawn(binary, ["--no-daemon", "app-server"], {
  cwd, stdio: ["pipe", "pipe", "ignore"],
});
let nextId = 0;
const pending = new Map();
const lines = createInterface({ input: child.stdout });
const deadline = setTimeout(() => fail(new Error("Codex catalog discovery timed out")), 20000);
function fail(error) {
  for (const { reject } of pending.values()) reject(error);
  pending.clear();
}
child.on("error", fail);
child.stdin.on("error", fail);
child.on("exit", () => fail(new Error("Codex catalog discovery exited before replying")));
lines.on("line", (line) => {
  let message;
  try { message = JSON.parse(line); } catch { fail(new Error("Codex returned invalid catalog protocol JSON")); return; }
  const request = pending.get(message.id);
  if (!request) return;
  pending.delete(message.id);
  if (message.error) request.reject(new Error(`Codex ${request.method} failed: ${message.error.message}`));
  else request.resolve(message.result);
});
function call(method, params) {
  return new Promise((resolve, reject) => {
    const id = ++nextId;
    pending.set(id, { resolve, reject, method });
    child.stdin.write(`${JSON.stringify({ id, method, params })}\n`);
  });
}
try {
  await call("initialize", { clientInfo: { name: "spudrunner-model-discovery", version: "1" } });
  child.stdin.write(`${JSON.stringify({ method: "initialized" })}\n`);
  const { config } = await call("config/read", { includeLayers: false });
  if (!config || typeof config !== "object") throw new Error("Codex config/read returned no configuration");
  // Codex's built-in default provider is openai. Its model/list does not prove
  // support for a custom provider; never route that provider to OpenAI's model.
  const provider = config.model_provider ?? "openai";
  if (provider !== "openai") throw new Error(`Codex provider '${provider}' has no verified recommendation discovery; pin its model with --model`);
  const models = [];
  let cursor = null;
  const cursors = new Set();
  do {
    const page = await call("model/list", { includeHidden: false, cursor });
    if (!Array.isArray(page?.data)) throw new Error("Codex model/list returned no model catalog");
    models.push(...page.data);
    cursor = page.nextCursor ?? null;
    if (cursor !== null && (typeof cursor !== "string" || cursors.has(cursor))) throw new Error("Codex model/list returned invalid pagination");
    cursors.add(cursor);
  } while (cursor !== null);
  const recommended = models.filter((model) => model.isDefault === true);
  if (recommended.length !== 1 || typeof recommended[0].model !== "string" || !/^[^\s\0]+$/.test(recommended[0].model)) {
    throw new Error("Codex catalog has no unique supported default recommendation");
  }
  const model = recommended[0];
  const effort = requestedEffort && requestedEffort !== "default" ? requestedEffort : config.model_reasoning_effort;
  if (effort && !model.supportedReasoningEfforts?.some((entry) => entry.reasoningEffort === effort)) {
    throw new Error(`Codex recommended model '${model.model}' does not advertise requested/inherited effort '${effort}'; pin a compatible model or effort`);
  }
  process.stdout.write(`${JSON.stringify({ model: model.model, provider, inheritedModel: config.model ?? null, effort: effort ?? null })}\n`);
} catch (error) {
  console.error(`error: ${error.message}; no worker launched. Resolve the selected runtime/provider catalog and pass --model explicitly; no inherited-model fallback was used.`);
  process.exitCode = 1;
} finally {
  clearTimeout(deadline);
  lines.close();
  child.stdin.destroy();
  child.kill("SIGTERM");
  // Only this discovery subprocess is owned here, never an existing daemon.
  const kill = setTimeout(() => child.kill("SIGKILL"), 1000);
  kill.unref();
  child.once("close", () => clearTimeout(kill));
}
