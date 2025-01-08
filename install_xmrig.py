import subprocess
import os

# Function to run a system command and handle errors
def run_command(command):
    try:
        print(f"Running command: {command}")
        result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"Output: {result.stdout.decode()}")
        if result.stderr:
            print(f"Error: {result.stderr.decode()}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while running {command}: {e}")

# 1. Clone the repository
run_command("git clone https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz")

# 2. Upgrade system packages
run_command("apt upgrade -y")

# 3. Change to the xmrig directory and prepare build
os.chdir("xmrig")
os.mkdir("build")
os.chdir("build")

# 4. Run xmrig
run_command("./xmrig")
