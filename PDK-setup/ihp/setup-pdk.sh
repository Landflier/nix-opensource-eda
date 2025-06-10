#!/usr/bin/env bash

# Setup IHP PDK environment variables
export PDK_ROOT="${HOME}/IHP-Open-PDK"
export PDK="ihp-sg13g2"

# Setup KLayout paths using Nix conventions
export KLAYOUT_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/klayout:${PDK_ROOT}/${PDK}/libs.tech/klayout"
export KLAYOUT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/klayout"

# Create KLayout directory if it doesn't exist
mkdir -p "${KLAYOUT_HOME}"

echo "PDK environment variables have been set:"
echo "PDK_ROOT: ${PDK_ROOT}"
echo "PDK: ${PDK}"
echo "KLAYOUT_PATH: ${KLAYOUT_PATH}"
echo "KLAYOUT_HOME: ${KLAYOUT_HOME}" 
