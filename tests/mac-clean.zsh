#!/usr/bin/env zsh
emulate -R zsh
setopt errexit nounset pipefail

script=${0:A:h:h}/bin/mac-clean
tmp=$(mktemp -d "${TMPDIR:-/tmp}/mac-clean-test.XXXXXXXX")
trap 'rm -rf -- "$tmp"' EXIT

fail() {
    print -u2 "FAIL: $*"
    exit 1
}

mkdir -p "$tmp/home/Code/project/node_modules" "$tmp/home/Projects" "$tmp/bin"
print tracked >"$tmp/home/Code/project/node_modules/keep.txt"
git -C "$tmp/home/Code/project" init -q
git -C "$tmp/home/Code/project" add -f node_modules/keep.txt

for command in brew npm pnpm yarn dotnet docker; do
    cat >"$tmp/bin/$command" <<'STUB'
#!/bin/sh
[ "$1" = info ] && exit 1
exit 0
STUB
    chmod +x "$tmp/bin/$command"
done

export PATH="$tmp/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Respect the configured project directory rather than always scanning ~/code.
mkdir -p "$tmp/home/CustomCode/project/node_modules"
print generated >"$tmp/home/CustomCode/project/node_modules/file"
HOME="$tmp/home" CODE_DEST="$tmp/home/CustomCode" TMPDIR="$tmp" "$script" --apply >/dev/null
[[ ! -e "$tmp/home/CustomCode/project/node_modules" ]] || fail 'configured CODE_DEST was not scanned'
export CODE_DEST="$tmp/home/Code"

# A tracked candidate must not be deleted.
HOME="$tmp/home" TMPDIR="$tmp" "$script" --apply >/dev/null
[[ -f "$tmp/home/Code/project/node_modules/keep.txt" ]] || fail 'tracked artifact was deleted'

# If Git cannot verify tracking status, fail closed and preserve the candidate.
cat >"$tmp/bin/git" <<'STUB'
#!/bin/sh
exit 1
STUB
chmod +x "$tmp/bin/git"
mkdir -p "$tmp/home/Code/other/node_modules"
print generated >"$tmp/home/Code/other/node_modules/file"
HOME="$tmp/home" TMPDIR="$tmp" "$script" --apply >"$tmp/output" 2>&1 || true
[[ -d "$tmp/home/Code/other/node_modules" ]] || fail 'artifact deleted when Git verification failed'
grep -q 'Unable to verify Git tracking status' "$tmp/output" || fail 'Git verification failure was not reported'

# Standard mode must still descend into retained dist/build directories.
rm -f "$tmp/bin/git"
mkdir -p "$tmp/home/Code/nested/dist/app/node_modules"
print '{}' >"$tmp/home/Code/nested/package.json"
print generated >"$tmp/home/Code/nested/dist/app/node_modules/file"
HOME="$tmp/home" TMPDIR="$tmp" "$script" --apply >/dev/null
[[ ! -e "$tmp/home/Code/nested/dist/app/node_modules" ]] || fail 'standard scan missed nested artifacts inside dist'

# Canonical aliases of one root are scanned only once.
mv "$tmp/home/Projects" "$tmp/home/Projects.original"
ln -s "$tmp/home/Code" "$tmp/home/Projects"
output=$(HOME="$tmp/home" TMPDIR="$tmp" "$script")
[[ $(grep -c '^Scanning:' <<<"$output") -eq 1 ]] || fail 'duplicate project roots were scanned'

# A failing find must be reported and reflected in the exit status.
cat >"$tmp/bin/find" <<'STUB'
#!/bin/sh
exit 1
STUB
chmod +x "$tmp/bin/find"
if HOME="$tmp/home" TMPDIR="$tmp" "$script" >"$tmp/scan-output" 2>&1; then
    fail 'scan failure returned success'
fi
grep -q 'Project scan failed' "$tmp/scan-output" || fail 'scan failure was not reported'

print 'mac-clean smoke tests passed'
