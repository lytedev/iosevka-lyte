{
  pkgs,
  parallel,
  python311Packages,
  iosevka-lyte,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  inherit (iosevka-lyte) version;

  pname = "${iosevka-lyte.pname}Subset";
  buildInputs =
    [ parallel ]
    ++ (with python311Packages; [
      fonttools
      brotli
    ]);
  PYTHONPATH = pkgs.python3.withPackages (pp: with pp; [ brotli ]);
  src = iosevka-lyte;

  installPhase = ''
    ls -la "${iosevka-lyte}/share/fonts/woff2"
    cp "${iosevka-lyte}"/share/fonts/woff2/*.woff2 ./
    cp "${iosevka-lyte}"/share/fonts/truetype/*.ttf ./
    echo ' !"#$%&'"'"'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ‌… ⎜⎡⎣─│┊└├┬╯░▒♯' > ./subset-glyphs.txt
    mkdir -p "$out/share/fonts/woff2"
    mkdir -p "$out/share/fonts/truetype"
    parallel pyftsubset --name-IDs+=0,4,6 --text-file=./subset-glyphs.txt --flavor=woff2 ::: ./*.woff2
    parallel pyftsubset --name-IDs+=0,4,6 --text-file=./subset-glyphs.txt ::: ./*.ttf
    cp ./*.subset.woff2 "$out/share/fonts/woff2"
    cp ./*.subset.ttf "$out/share/fonts/truetype"
    ls -laR
  '';
}
