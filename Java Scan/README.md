# Java Scan (Ansible)

Copy a shell script to a set of servers, run it, and pull the data it produces
back to this machine under `javaScanReport/`.

```
Java Scan/
├── playbook.yml          # copy -> execute -> fetch
├── inventory.ini         # target servers (edit this)
├── ansible.cfg           # host key checking off, inventory default
├── files/
│   └── java_scan.sh      # the script that runs on each server
├── javaScanReport/       # collected data lands here, one subfolder per host
└── README.md
```

## Requirements

- Ansible >= 2.14 on the machine running the playbook (the control node).
- SSH reachability to every host in `inventory.ini`, and a login that may run
  the script. Nothing needs to be installed on the targets beyond `bash`,
  `sed`, `tr`, `ps` and a package manager for the optional inventory bits.

## One password for all servers

`playbook.yml` uses `vars_prompt`, which runs **once per playbook execution**.
The single password typed at the start is stored in `ansible_password` and is
reused for every host:

```yaml
vars_prompt:
  - name: ansible_password
    prompt: "SSH password (used for every server)"
    private: true
```

The same value is aliased to `ansible_ssh_pass` (SSH) and
`ansible_become_password` (sudo), so enabling `scan_become` does not produce a
second prompt. To pass the password non-interactively (CI, scheduled run), use
`-e ansible_password=...` — `vars_prompt` skips a variable that is already
defined.

## Usage

Edit `inventory.ini` and list the servers:

```ini
[java_scan]
server-a ansible_host=20.0.0.4
server-b ansible_host=20.0.0.5 ansible_user=azureadmin
```

Then run from this directory:

```bash
ansible-playbook playbook.yml
```

Useful overrides:

```bash
# Login as a different user
ansible-playbook playbook.yml -e scan_user=azureadmin

# Run the script with sudo on the targets (same password, no extra prompt)
ansible-playbook playbook.yml -e scan_become=true

# Use your own script instead of files/java_scan.sh
ansible-playbook playbook.yml -e scan_script_src=/path/to/your_scan.sh

# Leave the remote working directory in place for inspection
ansible-playbook playbook.yml -e scan_cleanup=false

# Different inventory file
ansible-playbook playbook.yml -i production.ini
```

## What the playbook does

1. Creates `javaScanReport/<host>/` on the control node.
2. Copies `files/java_scan.sh` to `/tmp/java-scan-<host>/java_scan.sh` on each target.
3. Executes it: `bash /tmp/java-scan-<host>/java_scan.sh /tmp/java-scan-<host>/report.json`.
4. Saves the script's stdout/stderr to `javaScanReport/<host>/stdout.log`.
5. Fetches `/tmp/java-scan-<host>/report.json` back to
   `javaScanReport/<host>/report.json`.
6. Deletes `/tmp/java-scan-<host>` on the target (disable with `-e scan_cleanup=false`).

`fetch` runs only after the execute step finishes, so the report is complete.

## Output layout

```
javaScanReport/
├── server-a/
│   ├── report.json
│   └── stdout.log
└── server-b/
    ├── report.json
    └── stdout.log
```

`report.json` contains: hostname, UTC timestamp, OS label,
architecture, kernel, `JAVA_HOME`, `java -version`, `javac -version`, installed
java/jdk/jre packages, running java processes, and listening TCP ports.

`javaScanReport/.gitignore` keeps the fetched files out of git: scan output can
contain hostnames, package lists and process arguments. Delete it if you really
want the collected data committed.

## Using your own script

The playbook only assumes:

- the script is a shell script run with `bash`;
- it accepts the report path as its first argument and writes a file there;
- anything on stdout/stderr is worth keeping (it is saved to `stdout.log`).

If your script takes no argument and always writes to a fixed path, override
`scan_remote_report` to match and drop the argument by pointing
`scan_script_src` at a small wrapper.

## Notes

- `ansible.cfg` sets `host_key_checking = False` so the first run against a new
  host does not abort on an unknown key. Remove that line if you prefer to
  manage `known_hosts` explicitly.
- Hosts are processed in parallel; the password prompt still happens once.
- The scan script is read-only: it installs nothing and changes nothing.
