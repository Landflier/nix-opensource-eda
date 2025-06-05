{ lib
, stdenv
, fetchFromGitHub
, which
, perl
, python3
, ruby
, git
, qt5
, libgit2
}:

stdenv.mkDerivation rec {
  pname = "klayout";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = version;
    hash = "sha256-5e697uEuH2r/k/5qSuluJ2qvgCqM/Z+O0fZ7Lygdvz4=";
  };

  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    which
    perl
    python3
    ruby
    git
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qttools
    qt5.qtxmlpatterns
    qt5.wrapQtAppsHook
    libgit2
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/lib
    ./build.sh -qt5 -prefix $out/lib -option -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  postBuild =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir $out/bin

      install -Dm444 etc/klayout.desktop -t $out/share/applications
      install -Dm444 etc/logo.png $out/share/icons/hicolor/256x256/apps/klayout.png
      mv $out/lib/klayout $out/bin/
    '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-parentheses" ];

  dontInstall = true; 

  # Fix: "gsiDeclQMessageLogger.cc:126:42: error: format not a string literal
  # and no format arguments [-Werror=format-security]"
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${version}";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
} 