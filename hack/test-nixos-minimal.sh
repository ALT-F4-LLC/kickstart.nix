#!/usr/bin/env bash

# Get the relative path of the script -> the script's dir -> the dir's parent
# (i.e. the repo root) and convert it to an absolute path
root="$(realpath $(dirname $(dirname ${BASH_SOURCE[0]})))"
dir="$(mktemp -d)"

cd "$dir"

nix flake init -t "$root#nixos-minimal"

sudo mkdir -p /etc/nixos

sudo cat > /etc/nixos/hardware-configuration.nix <<EOF
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ];
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  networking.useDHCP = lib.mkDefault true;
  swapDevices = [ ];
}
EOF

cat /etc/nixos/hardware-configuration.nix

sed -i "s/<password>/password/g" flake.nix
sed -i "s/<username>/user/g" flake.nix
sed -i "s/throw //g" flake.nix
sed -i "s/ # TODO.*$//g" flake.nix

cat flake.nix

echo "Initialized in $dir, proceeding with build step"

nix build --impure --json .#nixosConfigurations.x86_64.config.system.build.toplevel

rm -rf /etc/nixos
