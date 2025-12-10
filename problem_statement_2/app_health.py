import sys
import requests
import time

def check_app_health(url):
    print(f"Checking application health for: {url}")
    try:
        response = requests.get(url, timeout=5)
        status_code = response.status_code
        
        if 200 <= status_code < 300:
            print(f"[UP] Status Code: {status_code}. Functioning correctly.")
            return True
        else:
            print(f"[DOWN] Status Code: {status_code}. Application unavailable or error.")
            return False
            
    except requests.exceptions.ConnectionError:
        print(f"[DOWN] Connection Error. Could not reach {url}.")
        return False
    except requests.exceptions.Timeout:
        print(f"[DOWN] Timeout. Application is slow to respond.")
        return False
    except Exception as e:
        print(f"[DOWN] Error: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 app_health.py <URL>")
        sys.exit(1)
    
    url = sys.argv[1]
    check_app_health(url)
