{
  description = "Example kickstart Rust application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit
          (pkgs)
          curlMinimal
          just
          rustPlatform
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
        inherit (rustPlatform) buildRustPackage;
        name = "example";
        version = "0.1.0";
      in {
        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [self'.packages.default];
            buildInputs = [just];
          };
        };

        packages = {
          default = buildRustPackage {
            inherit version;
            cargoSha256 = "sha256-OiAQhlQDTRqMELTO1ZUEvM5cNibghqJjfYrGL/nTVcc=";
            pname = name;
            src = ./.;
          };

          docker = buildImage {
            inherit name;
            tag = version;
            # https://ryantm.github.io/nixpkgs/builders/images/dockertools/#ssec-pkgs-dockerTools-helpers
            copyToRoot = [
              binSh
              caCertificates
              curlMinimal
              usrBinEnv
            ];
            config = {
              Cmd = ["${self'.packages.default}/bin/${name}"];
            };
          };
        };
      };
    };
}
