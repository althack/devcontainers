#!/usr/bin/env python3

import json
from pathlib import Path
import re


feature_root = Path(__file__).resolve().parents[2] / "src" / "ros2"

with (feature_root / "distributions.json").open(encoding="utf-8") as stream:
    config = json.load(stream)

with (feature_root / "devcontainer-feature.json").open(encoding="utf-8") as stream:
    manifest = json.load(stream)

ubuntu_releases = config["ubuntuReleases"]
proposals = manifest["options"]["distro"]["proposals"]
default = manifest["options"]["distro"]["default"]

if set(config) != {"ubuntuReleases"}:
    raise SystemExit("distributions.json must contain only ubuntuReleases")

distributions = []
for codename, settings in ubuntu_releases.items():
    expected_fields = {"version", "defaultDistro", "supportedDistros"}
    if set(settings) != expected_fields:
        raise SystemExit(
            f"{codename} must define exactly: {', '.join(sorted(expected_fields))}"
        )
    if not re.fullmatch(r"[a-z]+", codename):
        raise SystemExit(f"{codename} is not a valid Ubuntu codename")
    if not re.fullmatch(r"[0-9]{2}\.[0-9]{2}", settings["version"]):
        raise SystemExit(f"{codename} has an invalid Ubuntu version")
    if not settings["supportedDistros"]:
        raise SystemExit(f"{codename} must support at least one ROS 2 distribution")
    if settings["defaultDistro"] not in settings["supportedDistros"]:
        raise SystemExit(f"{codename}'s default must be one of its supported distros")
    for name in settings["supportedDistros"]:
        if name in distributions:
            raise SystemExit(f"ROS 2 {name} is listed for more than one Ubuntu release")
        distributions.append(name)

if not proposals or proposals[0] != "auto" or set(proposals[1:]) != set(distributions):
    raise SystemExit(
        "ROS 2 distro proposals must start with auto and contain every configured distribution"
    )

if len(proposals) != len(distributions) + 1:
    raise SystemExit("ROS 2 distro proposals must not contain duplicates")

if default != "auto":
    raise SystemExit("The default ROS 2 distro option must be auto")

print(f"Validated {len(distributions)} ROS 2 distribution definitions")
