{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, python3
, boost
, eigen
, spdlog
, tcl
, zlib
, bison
, flex
, swig
, cudd
, gtest
, wget
, unzip
, doxygen
, graphviz
, callPackage
}:

let
  lemon-graph = callPackage ./lemon-graph.nix {};
in

stdenv.mkDerivation rec {
  pname = "openroad";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "v2.0";
    sha256 = "sha256-cBjEna4R7ASmqGTR594yPXQUlT6UIJw+H5Rgu8tmOY4=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    wget
    unzip
    doxygen
    graphviz
  ];

  buildInputs = [
    boost
    eigen
    spdlog
    tcl
    zlib
    bison
    flex
    swig
    cudd
    lemon-graph
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-O2"
    "-DTCL_LIBRARY=${tcl}/lib/libtcl8.6.so"
    "-DTCL_HEADER=${tcl}/include"
    "-DZLIB_ROOT=${zlib}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_SYSTEM_EIGEN=ON"
    "-DUSE_SYSTEM_SPDLOG=ON"
    "-DUSE_SYSTEM_CUDD=ON"
    "-DUSE_SYSTEM_LEMON=ON"
    "-DUSE_SYSTEM_GTEST=ON"
    "-DLEMON_ROOT=${lemon-graph}"
    "-DCMAKE_PREFIX_PATH=${lemon-graph}/lib/cmake"
    "-DLEMON_DIR=${lemon-graph}/lib/cmake"
  ];

  meta = with lib; {
    description = "OpenROAD - Open-source electronic design automation tools";
    homepage = "https://theopenroadproject.org/";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
} 