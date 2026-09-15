{ pkgs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.rust = pkgs.mkShell {
      packages =
        with pkgs;
        [
          rustc
          cargo
          rustfmt
          clippy
          rust-analyzer
          llvmPackages.llvm
          pkg-config
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          pkgs.libiconv
        ];

      RUST_BACKTRACE = "1";

      shellHook = ''
        export CARGO_HOME="$PWD/.cargo"
        export LLVM_COV="${pkgs.llvmPackages.llvm}/bin/llvm-cov"
        export LLVM_PROFDATA="${pkgs.llvmPackages.llvm}/bin/llvm-profdata"
      '';
    };
  };
}
