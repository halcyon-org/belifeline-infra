#!/usr/bin/env bash

set -euo pipefail

./proxmox.bash
./network.bash
./vpn.bash
