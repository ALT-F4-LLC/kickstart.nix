#!/usr/bin/env bash

# Get the relative path of the script -> the script's dir -> the dir's parent
# (i.e. the repo root) and convert it to an absolute path
root="$(realpath $(dirname $(dirname ${BASH_SOURCE[0]})))"
dir="$(mktemp -d)"

cd "$dir"

nix flake init -t "$root#nixos-minimal"

sed -i "s/<password>/password/g" flake.nix
sed -i "s/<username>/user/g" flake.nix
sed -i "s/throw //g" flake.nix
sed -i "s/ # TODO.*$//g" flake.nix

cat flake.nix

echo "Initialized in $dir, proceeding with build step"

nix build --impure --json .#nixosConfigurations.x86_64.config.system.build.toplevel
