{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, git
, m4
, glibc
, tcl
, tk
, xorg
, cairo
, mesa
, mesa_glu
, python3
, tcsh
, ncurses
, freeglut
}:

stdenv.mkDerivation rec {
  pname = "magic-vlsi";
  version = "8.3.525";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    rev = version;
    sha256 = "sha256-PJk8RL4dQrcYR1GfmkovWqh6I+HEamqGVOLePs9V6lo=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    git
    m4
  ];

  buildInputs = [
    glibc
    tcl
    tk
    xorg.libX11
    cairo
    mesa
    mesa_glu
    python3
    tcsh
    ncurses
    freeglut
  ];

  # enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
  ];

  preBuild = ''
    chmod +x scripts/makedbh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  postPatch = ''
    patchShebangs scripts/*
  '';

  # Add a post install phase to copy to result directory
  postInstall = ''
    mkdir -p $NIX_BUILD_TOP/result/magic-vlsi
    cp -r $out/* $NIX_BUILD_TOP/result/magic-vlsi/
  '';

  meta = with lib; {
    description = "VLSI layout tool";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
