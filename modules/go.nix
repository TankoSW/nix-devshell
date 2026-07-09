{ pkgs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.go = pkgs.mkShell {
      packages = with pkgs; [
        go
        gopls
        delve
        gotools
      ];

      GOPATH = ".gopath";
      GOBIN = ".gopath/bin";
    };
  };
}
