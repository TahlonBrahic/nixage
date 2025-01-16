{pkgs ? import <nixpkgs> {}}: let
  goVersion = "1.23.3";
  version = "0.0.1";
  pname = "nixage";
  src = ./.;
in
  pkgs.stdenv.mkDerivation rec {
    inherit goVersion version pname src;

    buildInputs = [pkgs.go];

    GO111MODULE = "on";

    buildPhase = ''
      export HOME=$(pwd)
         mkdir -p $out/bin
         go build -o $out/bin -ldflags "-X main.Version=${version}" -trimpath ./cmd/...
    '';

    meta = with pkgs.lib; {
      description = "Modern encryption tool with small explicit keys";
      license = licenses.bsd3;
      maintainers = [];
    };
  }
