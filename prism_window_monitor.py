# prism_window_monitor.py
import hashlib
import time
import json
import os
from datetime import datetime

from hopping_agent_transmitter import trigger_hopping_agent
from crypto_tokenization import tokenize_payload, load_key

TRACE_BASELINE_FILE = "/tmp/prism_trace_baseline.json"

def capture_viewport_fingerprint():
    screen_state = os.popen("ps aux | grep -E 'session|chrome|Xorg|wayland'").read()
    fingerprint = hashlib.sha256(screen_state.encode()).hexdigest()
    return {
        "hash": fingerprint,
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "raw_len": len(screen_state),
    }

def load_baseline():
    if os.path.exists(TRACE_BASELINE_FILE):
        with open(TRACE_BASELINE_FILE, "r") as f:
            return json.load(f)
    baseline = capture_viewport_fingerprint()
    with open(TRACE_BASELINE_FILE, "w") as f:
        json.dump(baseline, f)
    return baseline

def initialize_trace_matrix():
    print("[*] Initializing 3D prism coordinate matrix for window buffer...")
    baseline = load_baseline()
    key = load_key()

    while True:
        current = capture_viewport_fingerprint()
        if current["hash"] != baseline["hash"]:
            print("[!] ALERT: Viewport state deviation detected. Session swap signature active.")
            payload = {
                "event": "session_swap",
                "baseline": baseline,
                "current": current,
            }
            raw = json.dumps(payload)
            token = tokenize_payload(raw, key)
            trigger_hopping_agent(token)
            baseline = current  # update baseline after hop
        time.sleep(2)

if __name__ == "__main__":
    initialize_trace_matrix()
