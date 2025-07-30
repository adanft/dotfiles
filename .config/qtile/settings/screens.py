from libqtile.config import Screen
from libqtile import bar
from .widgets import primary_widgets, get_secondary_widgets
import subprocess


def get_main_monitor():
    try:
        output = subprocess.check_output(
            "xrandr --query | grep ' connected primary'",
            shell=True
        ).decode().strip().splitlines()
        if output:
            return output[0].split()[0]
        return None
    except Exception:
        return None


def status_bar(widgets):
    return bar.Bar(widgets, 32, margin=[6, 6, 3, 6], background="#00000000")


screens = []


def get_connected_monitors():
    monitors = subprocess.check_output(
        "xrandr | grep ' connected'",
        shell=True
    ).decode()
    return [line.split()[0] for line in monitors.strip().split("\n")]


monitors_list = get_connected_monitors()
main_monitor = get_main_monitor()

if len(monitors_list) > 0:
    for i in range(0, len(monitors_list)):
        if main_monitor == monitors_list[i]:
            screens.append(Screen(top=status_bar(primary_widgets), bottom=bar.Gap(3), left=bar.Gap(3), right=bar.Gap(3)))
        else:
            screens.append(Screen(top=status_bar(get_secondary_widgets())))
