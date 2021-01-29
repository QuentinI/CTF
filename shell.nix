let 
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  imhex = import ./nix/imhex.nix { inherit pkgs; };

  packages = with pkgs; [
    imhex
    hyx

    metasploit
    wireshark
    termshark

    # Crypto
    hashcat
    john

    ## Web exploitation ##
    postman
    # chromiumDev
    sqlmap
    httpie
    wget curl
    bettercap
    masscan
    nmap
    zmap
    zeek
    burpsuite

    ## Binary exploitation and reverse engineering ##
    afl
    checksec
    elfkickers
    ghidra-bin
    capstone
    keystone
    rappel
    wasmer
    # rr

    ## Forensics ##
    steghide
    stegseek
    audacity
    sonic-visualiser
    multimon-ng
    exiftool
    ffmpeg-full
    volatility

    # Misc
    xxd
    bat
    fd
    ripgrep
    jq
  ];

  support-packages = with pkgs; [
    most
    nodePackages.prettier
    shfmt
    black
    xdg_utils
    pandoc
  ];

  getAttrByPathOrDefault = attrPath: e: default: if pkgs.lib.hasAttrByPath attrPath e then pkgs.lib.getAttrFromPath attrPath e else default;
  getPkgName = pkg: if builtins.hasAttr "pname" pkg then pkg.pname else getAttrByPathOrDefault ["meta" "name"] pkg "<no-name>";
  getPkgDesc = pkg: if pkgs.lib.hasAttrByPath ["meta" "longDescription"] pkg then pkg.meta.longDescription else getAttrByPathOrDefault ["meta" "description"] pkg "no description";
  getPkgDescription = pkg: 
  let
    name = getPkgName pkg;
    desc = "\t" + builtins.replaceStrings ["\n"] ["\n\t"] (getPkgDesc pkg);
  in
  ''
## ${name}


  ${desc}

  '';
  descriptions = pkgs.writeText "descriptions" ''
---
toc: true
---
${builtins.concatStringsSep "" (map (x: getPkgDescription x) packages)}
  '';
  help = pkgs.writeScriptBin "help" ''
    pandoc --toc --from markdown --to html ${descriptions} -o /tmp/help.html
    xdg-open /tmp/help.html
  '';

in

pkgs.mkShell {
  buildInputs = with pkgs; [
    (python3.withPackages
      (ps: with ps; [
        pwntools
        capstone
        binwalk-full
      ]))

    bashInteractive
    help
  ] ++ packages ++ support-packages;
}
