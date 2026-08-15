#!/usr/bin/env bash

set -euo pipefail

# The socket itself is provided by the feature's read-only bind mount. Create
# its parent so Docker can mount the host socket at the stable path.
install -d -m 0755 /tmp/devcontainer-pulse

echo "Configured Linux PulseAudio forwarding."
