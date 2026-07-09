{
  description = "Shared flake-parts devshell modules for Development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake = {
        flakeModules = {
          base = ./modules/base.nix;
          rust = ./modules/rust.nix;
          react = ./modules/react.nix;
        };

        templates = {
          rust = {
            path = ./templates/rust ;
            description = "Rust development environment";
          };

          react = {
            path = ./templates/react ;
            description = "React+Vite development environment";
          };
        };
      };

      perSystem = { ... }: { };
    };
}
