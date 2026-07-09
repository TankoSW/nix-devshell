{
  description = "Rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.follows = "tanko/flake-parts";

    tanko = {
      url = "github:TankoSW/nix-devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane.url = "github:ipetkov/crane";

    advisory-db = {
      url = "github:rustsec/advisory-db";
      flake = false;
    };
  };

  outputs = inputs@{
    flake-parts,
    tanko,
    crane,
    advisory-db,
    ...
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = with tanko.flakeModules; [
        base
        rust
      ];

      perSystem = { pkgs, config, ... }:
      let
        craneLib = crane.mkLib pkgs;

        src = craneLib.cleanCargoSource ./.;

        commonArgs = {
          inherit src;
          strictDeps = true;
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        package = craneLib.buildPackage (commonArgs // {
          inherit cargoArtifacts;
        });
      in {
        packages.default = package;

        checks = {
          inherit package;

          fmt = craneLib.cargoFmt {
            inherit src;
          };

          clippy = craneLib.cargoClippy (commonArgs // {
            inherit cargoArtifacts;
            cargoClippyExtraArgs = "--all-targets -- --deny warnings";
          });

          doc = craneLib.cargoDoc (commonArgs // {
            inherit cargoArtifacts;
            env.RUSTDOCFLAGS = "--deny warnings";
          });

          nextest = craneLib.cargoNextest (commonArgs // {
            inherit cargoArtifacts;
          });

          audit = craneLib.cargoAudit {
            inherit src advisory-db;
          };

          deny = craneLib.cargoDeny {
            inherit src;
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = with config.devShells; [
            base
            rust
          ];

          packages = with pkgs; [
            cargo-expand
            cargo-nextest
            cargo-audit
            cargo-deny
            cargo-edit
            cargo-watch
            cargo-outdated
            hyperfine
          ];

          shellHook = ''
            export CARGO_HOME="$PWD/.cargo"
          '';
        };
      };
    };
}
