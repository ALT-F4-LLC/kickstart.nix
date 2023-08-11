# kickstart.nix
Kickstart your Nix environment.


## Table of Contents

- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
- [Personalizing Your Environment](#personalizing-your-environment)


## Prerequisites

- Familiarity with terminal commands.
- An account on [GitHub](https://github.com/) for forking the repository.
- [GitHub CLI](https://github.com/cli/cli) (`gh`) installed for some commands.


## Initial Setup

Choose the appropriate setup instructions based on your operating system.

### macOS

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

6. Fork this repository to create your own flake kickstart.

> **Note**
> This can be done in the Github UI at: https://github.com/ALT-F4-LLC/kickstart.nix

```bash
gh repo fork ALT-F4-LLC/kickstart.nix
```

7. Clone your new fork locally to customize:

> **Note**
> If the following command does not work revist steps 1 & 2.

```bash
nix run nixpkgs#git clone https://github.com/<username>/kickstart.nix
```

8. Update the following value(s) in `flake.nix` configuration:

```nix
let
    username = "<insert-username>"; # replace
in
```

9. Switch to `kickstart.nix` environment for your system with flake configuration:

```bash
darwin-rebuild switch --flake ".#darwin-aarch64" # for M1/M2 Chipsets
darwin-rebuild switch --flake ".#darwin-x86_64" # for Intel Chipsets
```

### NixOS

1. Add the following to `/etc/nixos/configuration.nix` to enable `nix-command` and `flakes` features:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

2. Update you system to reflect the changes:

```bash
nixos-rebuild switch
```

3. Fork this repository to create your own flake kickstart.

> **Note**
> This can be done in the Github UI at: https://github.com/ALT-F4-LLC/kickstart.nix

```bash
gh repo fork ALT-F4-LLC/kickstart.nix
```

4. Clone your new fork locally to customize:

> **Note**
> If the following command does not work revist steps 1 & 2.

```bash
nix run nixpkgs#git clone https://github.com/<username>/kickstart.nix
```

5. Update the following value(s) in `flake.nix` configuration:

```nix
let
    username = "<insert-username>"; # replace
in
```

6. Switch to `kickstart.nix` environment for your system with flake configuration:

```bash
nixos-rebuild switch --flake ".#nixos-aarch64" # for ARM Chipsets
nixos-rebuild switch --flake ".#nixos-x86_64" # for Intel Chipsets
```


## Personalizing Your Environment

You can further tailor your Nix environment through configurations.

### Darwin

- `nix-darwin` system options exist in `./system/darwin.nix`
- `home-manager` system options exist in `./system/darwin.nix`

### NixOS

> **Important**
> The default user password can be found and updated in `./system/nixos.nix`.

- `nixos` system hardware options exist in `./system/nixos-hardware-configuration.nix`
- `nixos` system options exist in `./system/nixos.nix`
- `home-manager` system options exist in `./module/home-manager.nix`

### Shared

- `nix` system options exist in `./module/configuration.nix`
- `home-manager` user options exist in `./module/home-manager.nix`
