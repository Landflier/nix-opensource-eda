{ lib
, stdenv
, fetchFromGitHub
, python3
, icu
, bzip2
, zlib
, which
, gcc
}:

# Boost 1.86.0 - matches boostVersionSmall=1.86.0 from DependencyInstaller.sh
stdenv.mkDerivation rec {
  pname = "boost";
  version = "1.86.0";
  
  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "boost";
    rev = "boost-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-8Ra5VNQUpd29u3oHMmP6V2JQtvJJz2D+E33HPi+L6uA=";
  };

  nativeBuildInputs = [ python3 which gcc ];
  buildInputs = [ icu bzip2 zlib ];

  configurePhase = ''
    runHook preConfigure
    ./bootstrap.sh --prefix=$out --with-libraries=iostreams,test,serialization,system,thread
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./b2 -j $NIX_BUILD_CORES variant=release link=shared threading=multi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ./b2 install variant=release link=shared threading=multi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Boost C++ Libraries";
    homepage = "https://www.boost.org/";
    license = licenses.boost;
    platforms = platforms.unix;
  };
} 