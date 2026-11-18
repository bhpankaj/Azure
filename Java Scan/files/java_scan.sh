#!/usr/bin/env bash
#
# java_scan.sh - read-only Java inventory for one host.
#
# Usage: java_scan.sh [REPORT_FILE]
#
# Writes a JSON report (default /tmp/java-scan/java-scan-report.json) and prints
# a short human-readable summary on stdout. Nothing is installed or modified.
#
# The Ansible playbook passes the report path as the first argument, runs this
# with bash, then pulls the report back to javaScanReport/<host>/.

set -u

REPORT="${1:-/tmp/java-scan/java-scan-report.json}"
REPORT_DIR="$(dirname "$REPORT")"
mkdir -p "$REPORT_DIR" 2>/dev/null || true
REPORT_TMP="$REPORT.tmp.$$"

json_escape() {
    # Escape a string for a JSON double-quoted value (collapsed to one line).
    printf '%s' "$1" \
        | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/\\t/g' \
        | tr -d '\r\n'
}

to_json_array() {
    # $1: newline-separated input -> ["a","b"] (empty array when input empty).
    local input="$1" first=1 out="[" line
    while IFS= read -r line; do
        [ -n "$line" ] || continue
        if [ "$first" -eq 1 ]; then first=0; else out+=","; fi
        out+="\"$(json_escape "$line")\""
    done <<<"$input"
    out+="]"
    printf '%s' "$out"
}

timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo unknown)"
hostname="$(hostname 2>/dev/null || echo unknown)"
arch="$(uname -m 2>/dev/null || echo unknown)"
kernel="$(uname -sr 2>/dev/null || echo unknown)"

os_id="unknown"
os_version=""
os_name=""
if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release 2>/dev/null || true
    os_id="${ID:-unknown}"
    os_version="${VERSION_ID:-}"
    os_name="${PRETTY_NAME:-}"
fi
os_label="$os_name"
[ -n "$os_label" ] || os_label="$os_id${os_version:+ $os_version}"
[ -n "$os_label" ] || os_label="$kernel"

java_home="${JAVA_HOME:-}"

java_path=""
java_version=""
if command -v java >/dev/null 2>&1; then
    java_path="$(command -v java)"
    java_version="$(java -version 2>&1 | head -n 1)"
fi

javac_path=""
javac_version=""
if command -v javac >/dev/null 2>&1; then
    javac_path="$(command -v javac)"
    javac_version="$(javac -version 2>&1 | head -n 1)"
fi

# Installed packages, best effort per package manager.
packages=""
if command -v rpm >/dev/null 2>&1; then
    packages="$(rpm -qa 2>/dev/null | grep -Ei 'java|jdk|jre|openjdk' | sort || true)"
elif command -v dpkg-query >/dev/null 2>&1; then
    packages="$(dpkg-query -W -f='${Package}\n' 2>/dev/null | grep -Ei 'java|jdk|jre|openjdk' | sort || true)"
elif command -v pacman >/dev/null 2>&1; then
    packages="$(pacman -Qq 2>/dev/null | grep -Ei 'java|jdk|jre|openjdk' | sort || true)"
fi

# Running java processes (exclude this scan's own command line).
processes="$(ps -eo pid,user,args 2>/dev/null | grep -Ei '[j]ava' | grep -v 'java_scan' | head -n 50 || true)"

# Listening TCP ports, to help map java processes to services.
listeners=""
if command -v ss >/dev/null 2>&1; then
    listeners="$(ss -ltn 2>/dev/null | tail -n +2 || true)"
elif command -v netstat >/dev/null 2>&1; then
    listeners="$(netstat -ltn 2>/dev/null || true)"
fi

packages_json="$(to_json_array "$packages")"
processes_json="$(to_json_array "$processes")"
listeners_json="$(to_json_array "$listeners")"

{
    printf '{\n'
    printf '  "hostname": "%s",\n' "$(json_escape "$hostname")"
    printf '  "timestamp": "%s",\n' "$(json_escape "$timestamp")"
    printf '  "os": "%s",\n' "$(json_escape "$os_label")"
    printf '  "arch": "%s",\n' "$(json_escape "$arch")"
    printf '  "kernel": "%s",\n' "$(json_escape "$kernel")"
    printf '  "java_home": "%s",\n' "$(json_escape "$java_home")"
    printf '  "java": {"path": "%s", "version": "%s"},\n' \
        "$(json_escape "$java_path")" "$(json_escape "$java_version")"
    printf '  "javac": {"path": "%s", "version": "%s"},\n' \
        "$(json_escape "$javac_path")" "$(json_escape "$javac_version")"
    printf '  "packages": %s,\n' "$packages_json"
    printf '  "processes": %s,\n' "$processes_json"
    printf '  "listening_ports": %s\n' "$listeners_json"
    printf '}\n'
} > "$REPORT_TMP"
mv -f "$REPORT_TMP" "$REPORT"

pkg_count=0
[ -n "$packages" ] && pkg_count="$(printf '%s\n' "$packages" | grep -c .)"
proc_count=0
[ -n "$processes" ] && proc_count="$(printf '%s\n' "$processes" | grep -c .)"

# Summary on stdout; the playbook saves it next to the report as stdout.log.
printf 'host       : %s\n' "$hostname"
printf 'os         : %s (%s)\n' "$os_label" "$arch"
printf 'java       : %s\n' "${java_version:-not installed}"
printf 'java path  : %s\n' "${java_path:-not on PATH}"
printf 'javac      : %s\n' "${javac_version:-not installed}"
printf 'packages   : %s java-related package(s)\n' "$pkg_count"
printf 'processes  : %s java process line(s)\n' "$proc_count"
printf 'report     : %s\n' "$REPORT"
