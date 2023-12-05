# kickstart.nix
Kickstart your Nix environment.

[![Test NixOS Template(s)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-nixos.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-nixos.yml)
[![Test Darwin Template](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-darwin.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/test-darwin.yml)

![kickstart.nix](preview/kickstart.nix.webp)

## Table of Contents

- Languages
    - [Go (module)](#go-module)
    - [Go (package)](#go-package)
    - [Python (application)](#python-application)
    - [Python (package)](#python-package)
- Systems
    - [macOS (desktop)](#macos-desktop)
    - [NixOS (desktop)](#nixos-desktop)
    - [NixOS (minimal)](#nixos-minimal)
- Guides
    - [Setup macOS](#setup-macos)
    - [Setup NixOS](#setup-nixos)

### Languages

#### Go (module)

To be used with modern Go applications created with `go.mod` system. To build legacy Go applications use the `go-pkg` template.

> [!IMPORTANT]
> Be sure to update `go.mod` with proper repository after running `init` command.

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#go-mod
```

#### Go (package)

To be used with legacy Go applications that are **not** created with `go.mod` system. To build modern Go applications use the `go-mod` template.

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#go-pkg
```

#### Python (application)

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#python-app
```

#### Python (package)

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#python-pkg
```


### Systems

#### macOS (desktop)

macOS template allows you to run Nix tools on your native Mac hardware.

> [!TIP]
> This setup is ideal for developers already using macOS.

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#macos
```

#### NixOS (desktop)

NixOS desktop template includes the base operating system with GNOME (default) windows manager included. You can also use `plasma5` by changing the `desktop` value in the `flake.nix` file.

> [!TIP]
> This setup is ideal for getting started moving to NixOS as your main desktop.

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos-desktop
```

#### NixOS (minimal)

NixOS minimal template includes the base operating system without any windows manager.

> [!TIP]
> This setup is ideal for servers and other headless tasks.

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos-minimal
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
    password = throw "<password>"; # TODO: replace with password and remove throw 
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

7. Using `nix flake init` generate the `kickstart.nix` template of your choice locally:

```bash
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos-desktop
nix flake init --template github:ALT-F4-LLC/kickstart.nix#nixos-minimal
```

6. Update the following value(s) in `flake.nix` configuration:

- For `desktop` flake template:

```nix
let
    nixos-system = import ./system/nixos.nix {
        inherit inputs;
        username = throw "<username>"; # REQUIRED: replace with user name and remove throw
        password = throw "<password>"; # REQUIRED: replace with password and remove throw
        desktop = "gnome"; # optional: "gnome" by default, or "plasma5" for KDE Plasma
    };
in
```

- For `minimal` flake template:

```nix
let
    nixos-system = import ./system/nixos.nix {
        inherit inputs;
        username = throw "<username>"; # REQUIRED: replace with user name and remove throw
        password = throw "<password>"; # REQUIRED: replace with password and remove throw
    };
in
```

7. Switch to `kickstart.nix` environment for your system with flake configuration:

> [!IMPORTANT]
> We use `--impure` due to the way `/etc/nixos/hardware-configuration.nix` is generated and stored on the system after installation. To avoid using this flag, copy `hardware-configuration.nix` file locally and replace import in the template.

- For `aarch64` platforms:

```bash
sudo nixos-rebuild test --flake ".#aarch64" --impure # M Series Chipsets
sudo nixos-rebuild switch --flake ".#aarch64" --impure # M Series Chipsets
```

- For `x86_64` platforms:

```bash
sudo nixos-rebuild test --flake ".#x86_64"  --impure # Intel Chipsets
sudo nixos-rebuild switch --flake ".#x86_64" --impure # Intel Chipsets
```

Congrats! You've setup NixOS with Home Manager!

Be sure to explore the files below to get started customizing:

- `module/configuration.nix` for more `NixOS` system related settings
- `module/home-manager.nix` for `Home Manager` related settings
- `system/nixos.nix` for `NixOS` system related settings
