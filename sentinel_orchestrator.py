# sentinel_orchestrator.py
import os
import time
import subprocess

TMS_STATE_FILE = "/tmp/prism_tms_state"

def get_tms_state():
    if os.path.exists(TMS_STATE_FILE):
        with open(TMS_STATE_FILE, "r") as f:
            return f.read().strip()
    return "UNKNOWN"

def start_tms():
    # Fire-and-forget TMS in background
    subprocess.Popen(["bash", "tms_monitor.sh"])

def start_prism_monitor():
    subprocess.Popen(["python", "prism_window_monitor.py"])

def heartbeat_loop():
    print("[*] Sentinel heartbeat loop online.")
    while True:
        tms_state = get_tms_state()
        print(f"[*] Heartbeat | TMS={tms_state}")
        # You can add policy here: disable hopping if TMS=THROTTLE, etc.
        time.sleep(10)

if __name__ == "__main__":
    start_tms()
    start_prism_monitor()
    heartbeat_loop()
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
print("[*] Telemetry orchestrator bound to suprastar@netzero.net")
