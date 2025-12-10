import sys
import requests
import time

def check_status(target_url: str) -> bool:
    """
    Checks the HTTP status of the given URL.
    Returns True if 200-299, False otherwise.
    """
    print(f"Checking: {target_url} ...", end=" ", flush=True)
    
    try:
        r = requests.get(target_url, timeout=5)
        
        if r.ok: # Requests shortcut for 200-299
            print(f"[OK] {r.status_code}")
            return True
        else:
            print(f"[FAIL] Status {r.status_code}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"\n[ERROR] Connection failed: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 app_health.py <url>")
        sys.exit(1)
    
    url = sys.argv[1]
    check_status(url)
