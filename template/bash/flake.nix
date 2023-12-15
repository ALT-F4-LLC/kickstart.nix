{
  description = "Example kickstart Bash application project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          inherit (pkgs) dockerTools writeShellApplication;
          inherit (dockerTools) buildImage;
          name = "example";
          version = "0.1.0";
        in
        {
          packages = {
            default = writeShellApplication {
              inherit name;
              runtimeInputs = with pkgs; [ coreutils ];
              text = ''
                echo "Hello, world!"
              '';
            };

            docker = buildImage {
              inherit name;
              tag = version;
              config = {
                Cmd = "${self'.packages.default}/bin/${name}";
              };
            };
          };
        };
    };
}
