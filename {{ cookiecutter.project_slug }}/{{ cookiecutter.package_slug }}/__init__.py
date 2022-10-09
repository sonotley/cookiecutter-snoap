import os

with open(os.path.join(os.path.dirname(__file__), "version.txt")) as f:
    __version__ = f.read().strip()
