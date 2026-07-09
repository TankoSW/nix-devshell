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
          go = ./modules/go.nix;
        };

        templates = {
          go = {
            path = ./templates/go;
            description = "Go development environment using Tanko";
          };
        };
      };

      perSystem = { ... }: { };
    };
}
