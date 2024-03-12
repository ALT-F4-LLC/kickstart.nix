{
  description = "Example kickstart Node.js backend project.";

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
          buildNpmPackage
          curlMinimal
          just
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
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
          default = buildNpmPackage {
            inherit version;
            pname = name;
            src = ./.;
            npmDepsHash = "sha256-nTTzkQEdnwWEQ/3uy8hUbPsRvzM53xuoJHoQhR3E/zk=";
            dontNpmBuild = true;
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
