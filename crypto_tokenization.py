# crypto_tokenization.py
from Crypto.Cipher import AES
import base64
import os

DEFAULT_KEY_PATH = os.path.expanduser("~/.prism_trace_key")

def load_key():
    if os.path.exists(DEFAULT_KEY_PATH):
        with open(DEFAULT_KEY_PATH, "rb") as f:
            key = f.read().strip()
    else:
        key = os.urandom(16)
        with open(DEFAULT_KEY_PATH, "wb") as f:
            f.write(key)
    return key

def _pad_pkcs7(data: bytes, block_size: int = 16) -> bytes:
    pad_len = block_size - (len(data) % block_size)
    return data + bytes([pad_len]) * pad_len

def tokenize_payload(raw_data: str, key: bytes) -> str:
    # AES-ECB for simplicity; swap to CBC/GCM if you want stronger semantics.
    cipher = AES.new(key, AES.MODE_ECB)
    padded = _pad_pkcs7(raw_data.encode("utf-8"))
    encrypted = cipher.encrypt(padded)
    return base64.b64encode(encrypted).decode("utf-8")
