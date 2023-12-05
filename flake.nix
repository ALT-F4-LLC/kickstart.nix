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

      go-pkg = {
        description = "A minimal Go language package flake.";
        path = ./template/go-pkg;
      };

      nixos-desktop = {
        description = "A kickstart NixOS desktop environment flake.";
        path = ./template/nixos-desktop;
      };

      nixos-minimal = {
        description = "A kickstart NixOS minimal environment flake.";
        path = ./template/nixos-minimal;
      };

      python-app = {
        description = "A minimal Python application flake.";
        path = ./template/python-app;
      };

      python-pkg = {
        description = "A minimal Python package flake.";
        path = ./template/python-pkg;
      };
    };
  };
}
