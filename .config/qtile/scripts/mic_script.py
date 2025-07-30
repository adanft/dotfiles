import subprocess

mic_cmd = "wpctl"

def get_mic_status():
    result = subprocess.run(["wpctl", "get-volume", "@DEFAULT_SOURCE@"], stdout=subprocess.PIPE, text=True)
    return "" if "[MUTED]" in result.stdout else ""


def toggle_mic():
   subprocess.run(["wpctl", "set-mute", "@DEFAULT_SOURCE@", "toggle"])

