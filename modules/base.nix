{ pkgs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.base = pkgs.mkShell {
      packages = with pkgs; [
        git
        just
        pgcli
        jujutsu
        curl
        wget
      ];
    };
  };
}
