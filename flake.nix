{
  description = "Minimal templates to get started with Nix.";

  outputs = inputs: {
    templates = {
      darwin = {
        description = "A minimal Darwin development environment flake.";
        path = ./template/darwin;
      };

      go = {
        description = "A minimal Go language flake.";
        path = ./template/go;
      };

      nixos-gnome = {
        description = "A minimal NixOS development environment flake with GNOME.";
        path = ./template/nixos-gnome;
      };

      nixos-minimal = {
        description = "A minimal NixOS development environment flake.";
        path = ./template/nixos-minimal;
      };
    };
  };
}
