# kickstart.nix

Kickstart your Nix environments.

[![Test flake](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake.yml)
[![Test languages](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake-language.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake-language.yml)
[![Test systems](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake-system.yml/badge.svg)](https://github.com/ALT-F4-LLC/kickstart.nix/actions/workflows/flake-system.yml)

![kickstart.nix](preview/kickstart.nix.webp)

## Guides
- [Setup macOS](#setup-macos)
- [Setup NixOS](#setup-nixos)
## Templates
- Languages
    - [Bash](#bash)
    - [Go (module)](#go-module)
    - [Go (package)](#go-package)
    - [OCaml](#ocaml)
    - [Python (application)](#python-application)
    - [Python (package)](#python-package)
    - [Rust](#rust)
    - [Node.js (backend)](#nodejs-backend)
- Systems
    - [macOS (desktop)](#macos-desktop)
    - [NixOS (desktop)](#nixos-desktop)
    - [NixOS (minimal)](#nixos-minimal)

### Guides

#### Setup macOS

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
nix flake init -t github:ALT-F4-LLC/kickstart.nix#darwin
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

#### Setup NixOS

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
nix flake init -t github:ALT-F4-LLC/kickstart.nix#nixos-desktop
nix flake init -t github:ALT-F4-LLC/kickstart.nix#nixos-minimal
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
> We use `--impure` due to how `/etc/nixos/hardware-configuration.nix` is generated and stored on the system after installation. To avoid using this flag, copy `hardware-configuration.nix` file locally and replace import in the template [(see example here)](https://github.com/ALT-F4-LLC/dotfiles-nixos/blob/main/lib/default.nix#L30).

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

### Languages

#### Bash

Used for Bash scripts.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#bash
```

#### Go (module)

Used for modern Go apps setup with `go.mod` system. To build legacy Go apps, use `go-pkg` template.

> [!IMPORTANT]
> Be sure to update `go.mod` with proper repository after running `init` command.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#go-mod
```

#### Go (package)

Used for legacy Go apps **not** setup with `go.mod` system. To build modern Go apps, use `go-mod` template.

> [!IMPORTANT]
> Be sure to update `deps.nix` with vendor dependencies after running `init` command [(read more)](https://nixos.wiki/wiki/Go#buildGoPackage).

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#go-pkg
```

#### OCaml

Used for OCaml applications.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#ocaml
```

#### Python (application)

Used for runnable Python apps setup with `setup.py` and includes wrapped console scripts that can be executed from CLI. To build re-useable Python packages, use `python-pkg` template. 

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#python-app
```

#### Python (package)

Used for Python packages setup with `setup.py` that can be re-used within other Nix-built applications or packages. To build runnable Python apps, use `python-app` template. 

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#python-pkg
```

#### Rust

Used for Rust applications.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#rust
```

#### Node.js (backend)

Used for Node.js backend applications. The template builds using `npm`, and does
not assume you use TypeScript.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#nodejs-backend
```

To update your dependencies, install/upgrade them as normal via NPM, then use
the [`prefetch-npm-deps` package from nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/javascript.section.md#prefetch-npm-deps-javascript-buildnpmpackage-prefetch-npm-deps)
to generate a new `npmDepsHash` value for `packages.default` in the Flake.

```bash
$ nix shell 'nixpkgs#prefetch-npm-deps' -c prefetch-npm-deps package-lock.json
...
sha256-nTTzkQEdnwWEQ/3uy8hUbPsRvzM53xuoJHoQhR3E/zk=
```

> [!TIP]
> To add TypeScript, install it with `npm install --save-dev typescript`, add a
> `build` script to `package.json` that calls `tsc`, and then remove
> `dontNpmBuild = true;` from `packages.default` in your Flake.

### Systems

#### macOS (desktop)

macOS template allows you to run Nix tools on your native Mac hardware.

> [!TIP]
> This setup is ideal for developers already using macOS.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#darwin
```

#### NixOS (desktop)

NixOS desktop template includes base operating system with GNOME (default) windows manager included. You can also use `plasma5` by changing `desktop` value in `flake.nix` file.

> [!TIP]
> This setup is ideal for getting started moving to NixOS as your main desktop.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#nixos-desktop
```

#### NixOS (minimal)

NixOS minimal template includes base operating system without any windows manager.

> [!TIP]
> This setup is ideal for servers and other headless tasks.

```bash
nix flake init -t github:ALT-F4-LLC/kickstart.nix#nixos-minimal
```
