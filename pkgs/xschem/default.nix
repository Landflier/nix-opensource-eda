{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, tcl
, tk
, cairo
, flex
, bison
, libX11
, libXpm
, gawk
}:

stdenv.mkDerivation rec {
  pname = "xschem";
  version = "3.4.7";

  src = fetchFromGitHub {
    owner = "StefanSchippers";
    repo = "xschem";
    rev = version;
    sha256 = "sha256-RbhKf6U5GoettuGSIZLVTYTs0p+Ym4dX7o3IN4MKO7A=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    flex
    bison
    gawk
  ];

  buildInputs = [
    tcl
    tk
    cairo
    libX11
    libXpm
  ];

  meta = with lib; {
    description = "Schematic capture and netlisting EDA tool";
    homepage = "https://xschem.sourceforge.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
} 