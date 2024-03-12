{
  description = "Example kickstart Python application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

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
          python3Packages
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
        inherit (python3Packages) buildPythonApplication;
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
          default = buildPythonApplication {
            inherit version;
            buildInputs = []; # build and/or run-time (ie. non-Python dependencies)
            nativeBuildInputs = []; # build-time only (ie. setup_requires)
            nativeCheckInputs = []; # checkPhase only (ie. tests_require)
            pname = name;
            propagatedBuildInputs = []; # build-time only propogated (ie. install_requires)
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
              Cmd = ["${self'.packages.default}/bin/start"];
            };
          };
        };
      };
    };
}
