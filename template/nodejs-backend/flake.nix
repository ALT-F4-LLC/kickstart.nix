{
  description = "Example kickstart Node.js backend project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) dockerTools buildNpmPackage;
          inherit (dockerTools) buildImage;
          name = "example";
          version = "0.1.0";
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
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
              config = {
                Cmd = [ "${self'.packages.default}/bin/${name}" ];
                Env = [
                  "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                ];
              };
            };
          };
        };
    };
}
