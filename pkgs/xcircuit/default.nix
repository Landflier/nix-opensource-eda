{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, tcl
, tk
, libX11
, libXt
, ghostscript
, python3
, autoreconfHook
, automake
, cairo
}:

stdenv.mkDerivation rec {
  pname = "xcircuit";
  version = "3.10.30";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "XCircuit";
    rev = "3.10.30";
    sha256 = "sha256-YjaCJq0SXzt1iK8fwhw5nXXG6aV/r7ptCzdv1Fnws+Y=";  
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    automake
    pkg-config
  ];

  buildInputs = [
    tcl
    tk
    libX11
    libXt
    ghostscript
    python3
    cairo
  ];  

  hardeningDisable = [ "format" ];

  # Add CFLAGS to handle warnings
  # fixed compilation error with UDrawXAt
  NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-function-declaration"
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--with-python=${python3}/bin/python3"
    "--with-ghostscript=${ghostscript}/bin/gs"
  ];

  meta = with lib; {
    description = "Drawing program for circuit schematics and illustrations";
    homepage = "http://opencircuitdesign.com/xcircuit/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
} 