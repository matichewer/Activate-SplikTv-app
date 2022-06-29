import subprocess
import time
import os

command = '/bin/bash /spliktv/activate-app/spliktv.sh'
sleep_time = int(os.getenv('SLEEP_TIME'))

def activate():
    subprocess.run([command], shell=True)

def main():
    while True:
        activate()
        time.sleep(sleep_time)

if __name__ == "__main__":
        main()