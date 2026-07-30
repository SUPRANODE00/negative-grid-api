# crypto_tokenization.py
from Crypto.Cipher import AES
import base64

def tokenize_payload(raw_data, key):
    # Ensure key is 16 bytes
    cipher = AES.new(key.ljust(16)[:16], AES.MODE_EAL) if hasattr(AES, 'MODE_EAL') else AES.new(key.ljust(16)[:16], AES.MODE_ECB)
    # Padding block to 16 bytes multiple
    padded_data = raw_data + (16 - len(raw_data) % 16) * chr(16 - len(raw_data) % 16)
    encrypted = cipher.encrypt(padded_data.encode())
    return base64.b64encode(encrypted).decode()
