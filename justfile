temp_dir := "/tmp/kickstart.nix"

_default:
    just --list

build profile:
    nix build --json --no-link --print-build-logs "{{ profile }}"

check:
    nix flake check

clean-template template:
    rm -rf {{ temp_dir }}/{{ template }}
    mkdir -p {{ temp_dir }}/{{ template }}

build-template template: (clean-template template)
    #!/usr/bin/env bash
    DERIVATION=$(just build ".#example-{{ template }}")
    OUTPUT=$(echo $DERIVATION | jq -r ".[0].outputs.out")
    cp --no-preserve=mode -r $OUTPUT/* {{ temp_dir }}/{{ template }}

build-darwin system="x86_64": (build-template "darwin")
    just build "{{ temp_dir }}/darwin#darwinConfigurations.{{ system }}.config.system.build.toplevel"

build-home-manager system="x86_64-linux": (build-template "home-manager")
    just build "{{ temp_dir }}/home-manager#homeConfigurations.{{ system }}.activationPackage"

build-language template profile="default": (build-template template)
    just build "{{ temp_dir }}/{{ template }}#{{ profile }}"

build-nixos-desktop system="x86_64" desktop="gnome": (build-template 'nixos-desktop-'+desktop)
    just build "{{ temp_dir }}/nixos-desktop-{{ desktop }}#nixosConfigurations.{{ system }}.config.system.build.toplevel"

build-nixos-minimal system="x86_64": (build-template "nixos-minimal")
    just build "{{ temp_dir }}/nixos-minimal#nixosConfigurations.{{ system }}.config.system.build.toplevel"
