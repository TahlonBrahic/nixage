{
  lib,
  buildGoModule,
  fetchFromGitHub,
  goPackages,
  ...
}: let
  version =
    builtins.runCommand "get-version" {}
    ''
      git fetch --tags
      echo ${builtins.toString (
        builtins.runCommand "get-version" {}
        ''
          git describe --tags --always || echo "v0.0.0-$(git rev-parse --short HEAD)
        ''
      )}
    '';
in
  buildGoModule {
    pname = "age";
    inherit version;

    src = fetchFromGitHub {
      owner = "TahlonBrahic";
      repo = "nixage";
      rev = "main";
      sha256 = "sha256-2MA4j9FKF+jkvOavLFOnReMtt/lYKA1SbgpYBGcXXCA=";
    };

    nativeBuildInputs = [goPackages.git];

    meta = with lib; {
      description = "A simple and secure file encryption tool";
      license = licenses.bsd3;
    };
  }
