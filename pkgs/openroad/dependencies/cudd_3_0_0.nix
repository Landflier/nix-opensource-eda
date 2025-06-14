{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

# CUDD 3.0.0 - matches cuddVersion=3.0.0 from DependencyInstaller.sh
stdenv.mkDerivation rec {
  pname = "cudd";
  version = "3.0.0";
  
  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "cudd";
    rev = version;
    sha256 = "sha256-ybsFPcggPsb6lfZbWbwxNTuZSOC7lLNY/iZSTvyFmdU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-shared"
    "--enable-obj"
  ];

  meta = with lib; {
    description = "CUDD - Colorado University Decision Diagram package";
    homepage = "https://github.com/The-OpenROAD-Project/cudd";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
} 