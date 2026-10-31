import os, subprocess, sys
p = subprocess.Popen(sys.argv[1:])
while True:
    try:
        pid, status = os.waitpid(-1, 0)
    except InterruptedError:
        continue
    if pid == p.pid:
        sys.exit(os.WEXITSTATUS(status) if os.WIFEXITED(status) else 128 + os.WTERMSIG(status))
