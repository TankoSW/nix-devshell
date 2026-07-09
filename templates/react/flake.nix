{
  description = "React + Vite project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.follows = "tanko/flake-parts";

    tanko = {
      url = "github:TankoSW/nix-devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, tanko, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = with tanko.flakeModules; [
        base
        react
      ];

      perSystem = { pkgs, config, ... }: {

        devShells.default = pkgs.mkShell {
          inputsFrom = with config.devShells; [
            base
            react
          ];
        };
      };
    };
}
