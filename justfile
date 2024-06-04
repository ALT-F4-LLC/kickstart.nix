_default:
    just --list

check:
    nix flake check

build profile:
    #!/usr/bin/env bash
    set -euxo pipefail
    nix build --json --no-link --print-build-logs "{{ profile }}" \
    | jq -r ".[0].outputs.out"

build-template template temp_dir="$(mktemp -d)":
    #!/usr/bin/env bash
    set -euxo pipefail
    OUTPUT_DIR=$(just build "$PWD#example-{{ template }}")
    TEMP_DIR={{ temp_dir }}
    cp --no-preserve=mode -r $OUTPUT_DIR/* $TEMP_DIR/.
    echo $TEMP_DIR

build-darwin system="x86_64" temp_dir="$(mktemp -d)":
    #!/usr/bin/env bash
    set -euxo pipefail
    TEMP_DIR=$(just build-template "darwin" "{{ temp_dir }}")
    ls -alh $TEMP_DIR
    just build "$TEMP_DIR#darwinConfigurations.{{ system }}.config.system.build.toplevel"

build-home-manager system="x86_64-linux" temp_dir="$(mktemp -d)":
    #!/usr/bin/env bash
    set -euxo pipefail
    TEMP_DIR=$(just build-template "home-manager" "{{ temp_dir }}")
    ls -alh $TEMP_DIR
    just build "$TEMP_DIR#homeConfigurations.{{ system }}.activationPackage"

build-language language profile="default":
    #!/usr/bin/env bash
    set -euxo pipefail
    TEMP_DIR=$(just build-template "{{ language }}")
    ls -alh $TEMP_DIR
    just build "$TEMP_DIR"

build-nixos-desktop system="x86_64" desktop="gnome":
    #!/usr/bin/env bash
    set -euxo pipefail
    TEMP_DIR=$(just build-template "nixos-desktop-{{ desktop }}")
    ls -alh $TEMP_DIR
    just build "$TEMP_DIR#nixosConfigurations.{{ system }}.config.system.build.toplevel"

build-nixos-minimal system="x86_64":
    #!/usr/bin/env bash
    set -euxo pipefail
    TEMP_DIR=$(just build-template "nixos-minimal")
    ls -alh $TEMP_DIR
    just build "$TEMP_DIR#nixosConfigurations.{{ system }}.config.system.build.toplevel"
