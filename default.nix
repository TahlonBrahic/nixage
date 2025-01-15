{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "nixage";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "TahlonBrahic";
    repo = "nixage";
    rev = "v${version}";
    hash = "";
  };

  vendorHash = "";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = [installShellFiles];

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  # plugin test is flaky, see https://github.com/FiloSottile/age/issues/517
  checkFlags = [
    "-skip"
    "TestScript/plugin"
  ];

  meta = with lib; {
    changelog = "https://github.com/TahlonBrahic/nixage/releases/tag/v${version}";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    mainProgram = "nixage";
    maintainers = [];
  };
}
