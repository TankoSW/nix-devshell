{ pkgs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.rust = pkgs.mkShell {
      packages = with pkgs; [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
        pkg-config
      ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
        pkgs.libiconv
      ];

      RUST_BACKTRACE = "1";

      shellHook = ''
        export CARGO_HOME="$PWD/.cargo"
      '';
    };
  };
}
