{ pkgs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.react = pkgs.mkShell {
      packages = with pkgs; [
        nodejs_24
        pnpm
      ];

      shellHook = ''
        export PNPM_HOME="$PWD/.pnpm"
        export PATH="$PNPM_HOME:$PATH"
      '';
    };
  };
}
