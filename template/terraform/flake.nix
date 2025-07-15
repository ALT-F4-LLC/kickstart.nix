{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    providers-bin.url = "github:nix-community/nixpkgs-terraform-providers-bin";
    providers-bin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    providers-bin,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) mkShell terraform-docs;
        providersPackages = providers-bin.legacyPackages.${pkgs.system};
        terraform = pkgs.terraform.withPlugins (ps: [
          # The providers coming from nixpkgs have a flat namespace
          ps.null

          # The providers coming from nixpkgs-terraform-providers-bin have a 1:1
          # mapping with the terraform registry, replacing `/` with `.`:
          # https://registry.terraform.io/providers/hashicorp/random
          providersPackages.providers.hashicorp.random
        ]);
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        devShells = {
          default = mkShell {
            inputsFrom = [config.packages.default];
            nativeBuildInputs = [
              terraform
              terraform-docs
            ];

            shellHook = ''
              terraform init
              terraform fmt -recursive -write -diff
              terraform-docs .
            '';
          };
        };

        packages = {
          default =
            pkgs.runCommand "default" {
              src = ./.;
            } ''
              mkdir -p $out
              cp -R $src/*.tf $src/.*.yml $out

              ${terraform}/bin/terraform -chdir=$out init
              ${terraform}/bin/terraform -chdir=$out validate
              ${terraform-docs}/bin/terraform-docs $out/.
            '';
        };
      };
    };
}
