{
  description = "Go project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.follows = "tanko/flake-parts";

    tanko = {
      url = "github:lautaroacosta/tanko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = with inputs.tanko.flakeModules; [
        base
        go
      ];

      perSystem = { pkgs, config, ... }: {

        devShells.default = pkgs.mkShell {

          inputsFrom = with config.devShells; [
            base
            go
          ];

          packages = with pkgs; [
            # project-specific tools
          ];

          shellHook = ''
            export PATH="$PWD/bin:$PATH"
          '';
        };
      };
    };
}
