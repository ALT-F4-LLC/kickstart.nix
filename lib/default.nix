{inputs}: {
  flake = rec {
    mkDarwin = {runCommand}:
      runCommand "darwin"
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

    mkHomeManager = {runCommand}:
      runCommand "home-manager"
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

    mkLanguage = {
      name,
      runCommand,
      system,
    }:
      runCommand "${name}"
      {src = ../template/${name};} ''
        mkdir -p $out
        cp --no-preserve=mode -r $src/* $out
        cat $out/flake.nix
      '';

    mkNixosHardware = {runCommand}:
      runCommand "nixos-hardware" {} ''
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

    mkNixosDesktop = {
      callPackage,
      desktop,
      runCommand,
    }:
      runCommand "nixos-desktop"
      {
        hardware_configuration = callPackage mkNixosHardware {};
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

    mkNixosMinimal = {
      callPackage,
      runCommand,
    }:
      runCommand "nixos-minimal"
      {
        hardware_configuration = callPackage mkNixosHardware {};
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
  };
}
