# hopping_agent_transmitter.py
import socket
import random
import json
import time

ENDPOINTS = [
    ("127.0.0.1", 8080),
    ("127.0.0.1", 9090),
    ("127.0.0.1", 7070),
]

def _send_udp(payload_bytes, target_ip, target_port, timeout=1.0):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(timeout)
    try:
        sock.sendto(payload_bytes, (target_ip, target_port))
        return True
    except Exception as e:
        print(f"[-] Transmission error on hopping channel {target_ip}:{target_port} -> {e}")
        return False
    finally:
        sock.close()

def trigger_hopping_agent(state_token):
    print("[*] Deploying split-intelligence hopping agent package...")

    payload = {
        "agent_id": "PRISM-TRACER-01",
        "token": state_token,
        "status": "hopping_active",
        "hop_timestamp": time.time(),
    }
    payload_bytes = json.dumps(payload).encode()

    endpoints = ENDPOINTS.copy()
    random.shuffle(endpoints)

    for target_ip, target_port in endpoints:
        print(f"[*] Attempting hop to {target_ip}:{target_port}")
        if _send_udp(payload_bytes, target_ip, target_port):
            print(f"[+] Payload transmitted to endpoint: {target_ip}:{target_port}")
            return

    print("[-] All hopping endpoints failed. Agent remains side-attached but unsent.")
