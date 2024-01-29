{ inputs }:

{
  flake = rec {
    bash = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "bash"
        {
          src = ../template/bash;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    cpp-cmake = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "cpp-cmake"
        {
          src = ../template/cpp-cmake;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    darwin = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "darwin"
        {
          src = ../template/darwin;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        sed -i -e "s/<enter username in flake.nix>/username/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        cat $out/flake.nix
      '';

    go-mod = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "go-mod"
        {
          src = ../template/go-mod;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    go-pkg = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "go-pkg"
        {
          src = ../template/go-pkg;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    home-manager = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "home-manager"
        {
          src = ../template/home-manager;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        sed -i -e "s/<enter homeDirectory in flake.nix>/\/home\/username/g" $out/flake.nix
        sed -i -e "s/<enter username in flake.nix>/username/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        cat $out/flake.nix
      '';

    lua-app = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "lua-app"
        {
          src = ../template/lua-app;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
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
        sed -i -e "s/<enter username in flake.nix>/username/g" $out/flake.nix
        sed -i -e "s/<enter password in flake.nix>/password/g" $out/flake.nix
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
        sed -i -e "s/<enter username in flake.nix>/username/g" $out/flake.nix
        sed -i -e "s/<enter password in flake.nix>/password/g" $out/flake.nix
        sed -i -e "s/throw //g" $out/flake.nix
        sed -i -e "s/ # TODO.*$//g" $out/flake.nix
        sed -i -e "s/\/etc\/nixos\/hardware-configuration.nix/\.\/hardware-configuration.nix/g" $out/system/nixos.nix
        cat $out/flake.nix
        cat $out/system/nixos.nix
      '';

    nodejs-backend = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "nodejs-backend"
        {
          src = ../template/nodejs-backend;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    ocaml = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "ocaml"
        {
          src = ../template/ocaml;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    python-app = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "python-app"
        {
          src = ../template/python-app;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    python-pkg = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "python-pkg"
        {
          src = ../template/python-pkg;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    rust = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "rust"
        {
          src = ../template/rust;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    dart = system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      pkgs.runCommand "dart"
        {
          src = ../template/dart;
        } ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';
  };
}
