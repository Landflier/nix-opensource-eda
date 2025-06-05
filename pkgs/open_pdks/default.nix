{ lib
, stdenv
, fetchFromGitHub
, git
, wget
, curl
, gnused
, python3
, magic-vlsi
}:
 
stdenv.mkDerivation {
  pname = "open_pdks";
  version = "1.0.524";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "open_pdks";
    rev = "1.0.524";
    sha256 = "sha256-EDv+Og7LHDqRDCDfafoT6lllosOkIHUK8KVyRsf3pqo=";
    fetchSubmodules = true;
    leaveDotGit = true;
    deepClone = true;
  };

  nativeBuildInputs = [
    git
    wget
    curl
    gnused
    python3
  ];

  buildInputs = [
    magic-vlsi
  ];

  # Fix script permissions and paths
  postUnpack = ''
    patchShebangs $sourceRoot/scripts
    chmod +x $sourceRoot/scripts/download.sh
  '';

  preConfigure = ''
    # Store the absolute path to source
    export SOURCE_DIR="$(pwd)"
    
    # Fix paths in Makefiles
    for file in $(find . -type f -name "Makefile*"); do
      substituteInPlace "$file" \
        --replace-warn "\$(SCRIPTSDIR)/scripts" "$SOURCE_DIR/scripts" \
        --replace-warn "\$(SCRIPTSDIR)/sources" "$SOURCE_DIR/sources" \
        --replace-warn "\$(SCRIPTSDIR)/share" "$SOURCE_DIR/share" \
        --replace-warn "SCRIPTSDIR = .." "SCRIPTSDIR = $SOURCE_DIR" \
        --replace-warn "./scripts" "$SOURCE_DIR/scripts" \
        --replace-warn "./sources" "$SOURCE_DIR/sources" \
        --replace-warn "./share" "$SOURCE_DIR/share"
    done
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--enable-sky130-pdk"
    #"--enable-gf180mcu-pdk"
    "--disable-sc-7t5v0-gf180mcu"
    "--disable-sc-9t5v0-gf180mcu"
    "--disable-io-sky130"
    "--disable-sc-hs-sky130"
    "--disable-sc-ms-sky130"
    "--disable-sc-ls-sky130"
    "--disable-sc-lp-sky130"
    "--disable-sc-hd-sky130"
    "--disable-sc-hdll-sky130"
    "--disable-sc-hvl-sky130"
    "--disable-alpha-sky130"
  ];

  meta = with lib; {
    description = "Open Process Design Kits";
    homepage = "https://github.com/RTimothyEdwards/open_pdks";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
} 