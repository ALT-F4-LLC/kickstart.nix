# kickstart.nix
Kickstart your Nix environment.

[![Test NixOS Flake Template](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-nixos.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-nixos.yml)
[![Test Darwin Flake Template](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-darwin.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-darwin.yml)

![kickstart.nix](preview/kickstart.nix.webp)

## Table of Contents

- Languages
    - [Go](#go)
- Systems
    - [macOS](#macos)
    - [nixOS](#nixos)
- Guides
    - [Setup macOS](#setup-macos)
    - [Setup NixOS](#setup-nixos)

### Languages

#### Go

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#go
```

### Systems

#### macOS

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#macos
```

#### NixOS

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos
```

### Guides

### Setup macOS

1. Install `nixpkgs` with official script:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Install `nix-darwin` with official steps:

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

3. Answer the following with `y` to edit your default `configuration.nix` file:

```bash
Would you like to edit the default configuration.nix before starting? [y/n] y
```

4. Add the following to `configuration.nix` to enable `nix-command` and `flakes` features:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

5. Answer the following with `y` to setup `<darwin>` in `nix-channel` (though it won't be used):

```bash
Would you like to manage <darwin> with nix-channel? [y/n] y
```

6. Create a new directory for your `flake.nix` configuration:

```bash
mkdir -p ~/kickstart.nix
cd ~/kickstart.nix
```

7. Using `nix flake init` generate the `kickstart.nix` template locally:

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#darwin
```

8. Update the following value(s) in `flake.nix` configuration:

```nix
let
    password = throw "<username>"; # TODO: replace with password and remove throw 
    username = throw "<username>"; # TODO: replace with user name and remove throw 
in
```

9. Switch to `kickstart.nix` environment for your system with flake configuration:

```bash
darwin-rebuild switch --flake ".#aarch64" # M Series Chipsets
darwin-rebuild switch --flake ".#x86_64" # Intel Chipsets
```

Congrats! You've setup Nix with Home Manager on macOS!

Be sure to explore the files below to get started customizing:

- `system/darwin.nix` for all `nix-darwin` related settings
- `module/configuration.nix` for `Nix` related settings
- `module/home-manager.nix` for `Home Manager` related settings

### Setup NixOS

1. Install NixOS using the [latest ISO image](https://nixos.org/download#nixos-iso) for your system.

2. Add the following to `/etc/nixos/configuration.nix` to enable `nix-command` and `flakes` features:

```nix
nix.extraOptions = "experimental-features = nix-command flakes";
```

3. Update you system to reflect the changes:

```bash
sudo nixos-rebuild test
sudo nixos-rebuild switch
```

4. Create a new directory for your `flake.nix` configuration:

```bash
mkdir -p ~/kickstart.nix
cd ~/kickstart.nix
```

5. Using `nix flake init` generate the `kickstart.nix` template locally:

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos
```

6. Update the following value(s) in `flake.nix` configuration:

> **Important**
> The default user password can be found in `flake.nix`.

```nix
let
    password = throw "<password>"; # TODO: replace with password and remove throw 
    username = throw "<username>"; # TODO: replace with user name and remove throw 
in
```

7. Switch to `kickstart.nix` environment for your system with flake configuration:

```bash
sudo nixos-rebuild test --flake ".#aarch64" # M Series Chipsets
sudo nixos-rebuild switch --flake ".#aarch64" # M Series Chipsets

sudo nixos-rebuild test --flake ".#x86_64" # Intel Chipsets
sudo nixos-rebuild switch --flake ".#x86_64" # Intel Chipsets
```

Congrats! You've setup NixOS with Home Manager!

Be sure to explore the files below to get started customizing:

- `system/hardware-configuration.nix` for `NixOS` hardware related settings
- `system/nixos.nix` for `NixOS` system related settings
- `module/configuration.nix` for more `NixOS` system related settings
- `module/home-manager.nix` for `Home Manager` related settings
