{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "openroad";
  version = "2.0";

  src = pkgs.fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "v2.0";
    sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
    python3
  ];

  buildInputs = with pkgs; [
    boost
    eigen
    spdlog
    tcl
    zlib
    bison
    flex
    swig
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_SYSTEM_EIGEN=ON"
    "-DUSE_SYSTEM_SPDLOG=ON"
  ];

  meta = with pkgs.lib; {
    description = "OpenROAD - Open-source electronic design automation tools";
    homepage = "https://theopenroadproject.org/";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
} 