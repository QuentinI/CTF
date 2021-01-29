{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "ImHex";
  version = "1.6.1";

  src = pkgs.fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex";
    rev = "a09aec032f9542c4866defa69676b6da9cbf62e7";
    sha256 = "190lj36965dzl2a4z5i45fsla5iryxw2m5aj7rfmakajpkrvk4jf";
  };

  doCheck = true;

  nativeBuildInputs = [
    pkgs.cmake
  ];

  buildInputs = [
    pkgs.pkg-config 
    pkgs.openssl.dev 
    pkgs.capstone 
    pkgs.glfw 
    pkgs.nlohmann_json 
    pkgs.freetype 
    pkgs.xorg.libX11 
    pkgs.xorg.libXau 
    pkgs.xorg.libxcb 
    pkgs.xorg.libXdmcp 
    pkgs.file
    pkgs.glm
    pkgs.python3
  ];

  meta = with pkgs.lib; {
    description = "ImHex hex editor";
    longDescription = ''
      A Hex Editor for Reverse Engineers, Programmers and people that value their eye sight when working at 3 AM. 
    '';
    homepage = "https://github.com/WerWolv/ImHex";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
