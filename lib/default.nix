{ inputs }:

{
  flake = rec {
    darwin = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "darwin"
        {
          buildInputs = with pkgs; [ coreutils ];
          src = ../template/darwin;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        sed -i -e "s/<username>/username/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        cat $out/flake.nix
      '';

    nixos-desktop = system: desktop:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "nixos-desktop"
        {
          hardware_configuration = nixos-hardware system;
          src = ../template/nixos-desktop;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cp --no-preserve=mode $hardware_configuration $out/system/hardware-configuration.nix
        sed -i -e "s/<username>/username/g" $out/flake.nix
        sed -i -e "s/<password>/password/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        sed -i -e "s/desktop = \"gnome\"/desktop = \"${desktop}\"/g" $out/flake.nix
        sed -i -e "s/\/etc\/nixos\/hardware-configuration.nix/\.\/hardware-configuration.nix/g" $out/system/nixos.nix
        cat $out/flake.nix
        cat $out/system/nixos.nix
      '';

    nixos-hardware = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "nixos-hardware" { } ''
        cat > $out <<EOF
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
        cat $out
      '';

    nixos-minimal = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "nixos-minimal"
        {
          hardware_configuration = nixos-hardware system;
          src = ../template/nixos-minimal;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cp --no-preserve=mode $hardware_configuration $out/system/hardware-configuration.nix
        sed -i -e "s/<username>/username/g" $out/flake.nix
        sed -i -e "s/<password>/password/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        sed -i -e "s/\/etc\/nixos\/hardware-configuration.nix/\.\/hardware-configuration.nix/g" $out/system/nixos.nix
        cat $out/flake.nix
        cat $out/system/nixos.nix
      '';
  };
}
