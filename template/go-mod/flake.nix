{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          name = "<package-name>";
          version = "latest";
          vendorHash = null; # update whenever go.mod changes
        in
        {
          devShells = {
            default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
            };
          };

          packages = {
            default = pkgs.buildGoModule {
              name = name;
              src = ./.;
              subPackages = [ "cmd/example" ];
              vendorHash = vendorHash;
            };

            docker = pkgs.dockerTools.buildDockerImage {
              name = "${name}-docker";
              tag = version;

              config = {
                Cmd = "${self'.packages.default}/bin/${name}";
              };

              created = "now";
            };
          };
        };
    };
}
