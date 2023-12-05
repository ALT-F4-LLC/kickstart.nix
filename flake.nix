{
  description = "Minimal templates to get started with Nix.";

  outputs = inputs: {
    templates = {
      darwin = {
        description = "A minimal Darwin development environment flake.";
        path = ./template/darwin;
      };

      go-mod = {
        description = "A minimal Go language module flake.";
        path = ./template/go-mod;
      };

      nixos-desktop = {
        description = "A kickstart NixOS desktop environment flake.";
        path = ./template/nixos-desktop;
      };

      nixos-minimal = {
        description = "A kickstart NixOS minimal environment flake.";
        path = ./template/nixos-minimal;
      };
    };
  };
}
