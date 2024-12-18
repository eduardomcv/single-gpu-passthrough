#!/bin/bash

set -euo pipefail

sudo ln -s "$PWD/hooks" /etc/libvirt/hooks

echo Added hooks symlink to libvirt directory.
