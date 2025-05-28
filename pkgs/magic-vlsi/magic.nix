{ lib
, stdenv
, fetchFromGitHub
, tcl
, git
, cairo
, tcsh
, python3
, tk
, m4
, ncurses
, libGLU
  # undocumented packages required
, freeglut
, mesa
}:
stdenv.mkDerivation {
  name = "magic";

  buildInputs = [
    tcl
    git
    cairo
    tcsh
    python3
    tk
    m4
    ncurses
    libGLU
    # undocumented packages required
    freeglut
    mesa
  ];

  makeFlags = [];

  configureFlags = [
    "--with-tcl=${tcl}/lib/"
    "--with-tk=${tk}/lib/"
  ];

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    rev = "8.3.440";
    sha256 = "1c94m6pcbvs3ppvrkbbccwh30lmyssvzm6hylf4jwrbyqll078sg";
  };
}
