# kickstart.nix
Kickstart your Nix environment.

## Overview

We want to provide multiple examples on how to setup Nix on various systems.

## Setup

- Install `nixpkgs` with official script

```bash
sh <(curl -L https://nixos.org/nix/install)
```

- Install `nix-darwin` (only for macOS)

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

- Create a simple flake using one of the examples below:

#### macOS (using nix-darwin)
```nix
{
  description = "Example kickstart Nix development setup.";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      flake =
        let
          system = "<insert-archtype>";
          username = "<insert-username>";
        in
        {
          darwinConfigurations = {
            kickstart = inputs.darwin.lib.darwinSystem
              {
                system = system;
                modules = [
                  inputs.home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users."${username}" = { pkgs, ... }: {
                      home.packages = [ pkgs.neovim ];
                    };
                  }
                ];
              };
          };
        };
    };
}
```

#### NixOS 
```nix
{
  description = "Example kickstart Nix development setup.";

  inputs = {
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      flake =
        let
          system = "<insert-archtype>";
          username = "<insert-username>";
        in
        {
          nixosConfigurations = {
            kickstart = inputs.nixpkgs.lib.nixosSystem
              {
                inherit system;
                modules = [
                  ./hardware-configuration.nix # may need to update this path

                  inputs.home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users."${username}" = { pkgs, ... }: {
                      home.packages = [ pkgs.neovim ];
                    };
                  }
                ];
              };
          };
        };
    };
}
```

- Switch to `kickstart.nix` environment with flake configuration

#### macOS
```bash
darwin-rebuild switch --flake ".#kickstart"
```

#### NixOS
```bash
nixos-rebuild switch --flake ".#kickstart"
```
