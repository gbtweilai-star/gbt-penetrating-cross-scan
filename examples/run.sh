#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_penetrating_cross_scan info
PYTHONPATH=src python -m gbt_penetrating_cross_scan check --payload '{}'
PYTHONPATH=src python -m gbt_penetrating_cross_scan run   --payload '{}'
