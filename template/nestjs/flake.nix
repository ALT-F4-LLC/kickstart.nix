{
  description = "Example kickstart NestJS project.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        self',
        ...
      }: let
        inherit
          (pkgs)
          buildNpmPackage
          curlMinimal
          just
          nodejs
          stdenv
          writeScriptBin
          ;
        inherit
          (pkgs.dockerTools)
          binSh
          buildImage
          caCertificates
          usrBinEnv
          ;
        pname = "example";
        version = "0.1.0";
      in {
        packages = {
          default = let
            app =
              buildNpmPackage.override {inherit nodejs;}
              {
                inherit pname version;
                nativeBuildInputs = [
                  nodejs.pkgs.npm
                ];
                src = ./.;
                npmDepsHash = "sha256-hbwRj8D3t8bmAQBWjkvIk8oa3M2snHdCbewXc3nOZ5Y=";
                installPhase = ''
                  mkdir -p $out/bin
                  cp -r node_modules $out/node_modules
                  cp -r dist $out/dist
                '';
              };
          in
            writeScriptBin "${pname}" ''
              #!${stdenv.shell} -e
              ${nodejs}/bin/node ${app}/dist/main.js
            '';

          docker = buildImage {
            name = pname;
            tag = version;
            # https://ryantm.github.io/nixpkgs/builders/images/dockertools/#ssec-pkgs-dockerTools-helpers
            copyToRoot = [
              binSh
              caCertificates
              curlMinimal
              usrBinEnv
            ];
            config = {
              Cmd = "${self'.packages.default}/bin/${pname}";
            };
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [self'.packages.default];
          buildInputs = [just];
        };
      };
    };
}
