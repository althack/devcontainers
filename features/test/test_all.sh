#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

for test_script in "${repo_root}"/features/test/*/test.sh; do
  bash "${test_script}"
done
