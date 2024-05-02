{
  description = "Example kickstart Go module project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, pkgs, ... }:
        let
          name = "example";
          version = "latest";
          vendorHash = null; # update whenever go.mod changes
        in
        {
          devShells = {
            default = pkgs.mkShell {
              buildInputs = [ pkgs.go_1_22 ];
              inputsFrom = [ config.packages.default ];
            };
          };

          packages = {
            default = pkgs.buildGo122Module {
              inherit name vendorHash;
              src = ./.;
              subPackages = [ "cmd/example" ];
            };

            docker = pkgs.dockerTools.buildImage {
              inherit name;
              tag = version;
              config = {
                Cmd = [ "${config.packages.default}/bin/${name}" ];
                Env = [
                  "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                ];
              };
            };
          };
        };
    };
}
