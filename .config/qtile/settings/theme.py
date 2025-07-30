import os
import json


def load_theme(name="mocha"):
    path = os.path.join(os.path.dirname(__file__), "../themes", f"{name}.json")
    with open(path, "r") as f:
        return json.load(f)


colors = load_theme()
