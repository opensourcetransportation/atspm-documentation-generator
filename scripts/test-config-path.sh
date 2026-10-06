#!/usr/bin/env bash
set -euo pipefail
script_root="$(cd "$(dirname "$0")" && pwd)"
temp_root="$(realpath "${TMPDIR:-/tmp}")"
fixture="$(mktemp -d "$temp_root/atspm-config-path.XXXXXXXX")"
cleanup() {
  local resolved
  resolved="$(realpath -e "$fixture")"
  if [[ "$resolved" == "$temp_root"/atspm-config-path.* && "$(dirname "$resolved")" == "$temp_root" ]]; then
    rm -rf -- "$resolved"
  fi
}
trap cleanup EXIT
mkdir -p "$fixture/action/config" "$fixture/source checkout/GenerateDocuments"
printf '{}' > "$fixture/action/config/container-config-map.json"
printf '{}' > "$fixture/source checkout/GenerateDocuments/documentation.json"

resolve() {
  bash "$script_root/resolve-config-path.sh" "$fixture/source checkout" "$fixture/action" "$1"
}
expected="$(realpath "$fixture/source checkout/GenerateDocuments/documentation.json")"
[[ "$(resolve '')" == "$(realpath "$fixture/action/config/container-config-map.json")" ]]
[[ "$(resolve 'GenerateDocuments/documentation.json')" == "$expected" ]]
[[ "$(resolve "$fixture/source checkout/GenerateDocuments/documentation.json")" == "$expected" ]]
for invalid in 'missing.json' 'GenerateDocuments' $'bad\npath'; do
  if resolve "$invalid" > "$fixture/output" 2> "$fixture/error"; then
    echo "Unexpected success for invalid configuration path" >&2
    exit 1
  fi
  test -s "$fixture/error"
  test ! -s "$fixture/output"
done
echo "Configuration path checks passed (default, relative, absolute, spaces, missing, directory, newline)."
