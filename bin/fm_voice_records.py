#!/usr/bin/env python3
"""Compatibility entrypoint; use voice_records.py for new callers."""
import sys
from voice_records import *  # noqa: F401,F403
from voice_records import active_work_status, main

fleet_status = active_work_status

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
