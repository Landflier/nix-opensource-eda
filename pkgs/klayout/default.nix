{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "klayout";
  version = "0.30.1";

  src = pkgs.fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "0.30.1";
    hash = "sha256-5e697uEuH2r/k/5qSuluJ2qvgCqM/Z+O0fZ7Lygdvz4=";
  };


  postPatch = ''
    substituteInPlace src/klayout.pri --replace "-Wno-reserved-user-defined-literal" ""
    patchShebangs .
  '';

  nativeBuildInputs = with pkgs; [
    which
    perl
    python3
    ruby
  ];

  buildInputs = with pkgs; [
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
    pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
      mkdir $out/bin

      install -Dm444 etc/klayout.desktop -t $out/share/applications
      install -Dm444 etc/logo.png $out/share/icons/hicolor/256x256/apps/klayout.png
      mv $out/lib/klayout $out/bin/
    '';

  # Add a post install phase to copy to results directory
  postInstall = ''
    mkdir -p $NIX_BUILD_TOP/results/klayout
    cp -r $out/* $NIX_BUILD_TOP/results/klayout/
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-parentheses" ];

  dontInstall = false; # We need the install phase now

  # Fix: "gsiDeclQMessageLogger.cc:126:42: error: format not a string literal
  # and no format arguments [-Werror=format-security]"
  hardeningDisable = [ "format" ];

  meta = with pkgs.lib; {
    description = "High performance layout viewer and editor with support for GDS and OASIS";
    mainProgram = "klayout";
    license = with licenses; [ gpl2Plus ];
    homepage = "https://www.klayout.de/";
    changelog = "https://www.klayout.de/development.html#${version}";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
} 