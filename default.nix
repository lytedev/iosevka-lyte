{
  fetchFromGitHub,
  fetchNpmDeps,
  iosevka,
  set ? "LyteTerm",
  pname ? "Iosevka${set}",
  version ? "33.2.2",
  hash ? "sha256-dhMTcceHru/uLHRY4eWzFV+73ckCBBnDlizP3iY5w5w=",
  npmDepsHash ? "sha256-5DcMV9N16pyQxRaK6RCoeghZqAvM5EY1jftceT/bP+o=",
  ...
}:
let
  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    inherit hash;
  };
  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-${version}-npm-deps";
    hash = npmDepsHash;
  };
in
(
  (iosevka.override {
    inherit set;

    privateBuildPlan = ''
      [buildPlans.${pname}]
      family = "${pname}"
      spacing = "fontconfig-mono"
      serifs = "sans"
      exportGlyphNames = true

      [buildPlans.${pname}.ligations]
      inherits = "dlig"
      disables = [ "exeqeqeq", "exeqeq", "eqexeq-dl", "exeq", "tildeeq" ]

      [buildPlans.${pname}.weights.regular]
      shape = 400
      menu  = 400
      css   = 400

      [buildPlans.${pname}.weights.book]
      shape = 450
      menu  = 450
      css   = 450

      [buildPlans.${pname}.weights.bold]
      shape = 700
      menu  = 700
      css   = 700

      [buildPlans.${pname}.weights.black]
      shape = 900
      menu  = 900
      css   = 900

      ## [[buildPlans.${pname}.compatibility-ligatures]]
      ## unicode = 57600 # 0xE100
      ## featureTag = 'calt'
      ## kequence = '<*>'

      [buildPlans.${pname}.variants]
      inherits = "ss01"

      [buildPlans.${pname}.variants.design]
      capital-a = 'curly-serifless'
      capital-b = 'standard-interrupted-serifless'
      capital-c = 'unilateral-inward-serifed'
      capital-d = 'standard-serifless'
      capital-g = 'toothless-rounded-inward-serifed-hooked'
      capital-i = 'serifed'
      capital-j = 'serifed'
      capital-k = 'curly-serifless'
      capital-l = 'motion-serifed'
      capital-m = 'hanging-serifless'
      capital-n = 'asymmetric-serifless'
      capital-p = 'open-serifless'
      capital-q = 'crossing'
      capital-r = 'standing-open-serifless'
      capital-s = 'unilateral-inward-serifed'
      capital-t = 'motion-serifed'
      capital-u = 'toothless-corner-serifless'
      capital-v = 'curly-serifless'
      capital-w = 'curly-serifless'
      capital-x = 'curly-serifless'
      capital-y = 'curly-base-serifed'
      capital-z = 'curly-top-serifed-with-crossbar'
      a = 'double-storey-toothless-corner'
      b = 'toothless-corner-serifless'
      c = 'unilateral-inward-serifed'
      d = 'toothless-corner-serifless'
      e = 'flat-crossbar'
      f = 'tailed'
      g = 'double-storey-open'
      # g = 'single-storey-earless-corner-flat-hook'
      h = 'straight-serifless'
      i = 'tailed-serifed'
      j = 'serifed'
      k = 'curly-serifless'
      l = 'tailed-serifed'
      m = 'earless-corner-double-arch-serifless'
      n = 'earless-corner-straight-serifless'
      p = 'earless-corner-serifless'
      q = 'earless-corner-diagonal-tailed-serifless'
      r = 'earless-corner-serifless'
      s = 'unilateral-inward-serifed'
      t = 'bent-hook-asymmetric'
      u = 'toothless-corner-serifless'
      v = 'curly-serifless'
      w = 'curly-serifless'
      x = 'curly-serifless'
      y = 'curly-turn-serifless'
      z = 'curly-top-serifed-with-crossbar'
      # cyrl-capital-ze = 'unilateral-inward-serifed'
      zero = 'reverse-slashed-split'
      one = 'base'
      two = 'curly-neck-serifless'
      three = 'two-arcs'
      four = 'semi-open-non-crossing-serifless'
      # five = 'vertical-upper-left-bar'
      five = 'upright-flat-serifless'
      six = 'straight-bar'
      seven = 'curly-serifed-crossbar'
      eight = 'two-circles'
      nine = 'straight-bar'
      tilde = 'low'
      asterisk = 'penta-low'
      underscore = 'above-baseline'
      pilcrow = 'low'
      caret = 'low'
      paren = 'flat-arc'
      brace = 'curly-flat-boundary'
      number-sign = 'upright-open'
      ampersand = 'upper-open'
      at = 'compact'
      dollar = 'interrupted'
      cent = 'open'
      percent = 'rings-segmented-slash'
      bar = 'force-upright'
      ascii-single-quote = 'raised-comma'
      ascii-grave = 'straight'
      question = 'smooth'
      punctuation-dot = 'round'
    '';
  }).overrideAttrs
  {
    inherit
      pname
      version
      npmDepsHash
      src
      npmDeps
      ;

    buildPhase = ''
      export HOME="$TMPDIR"
      runHook preBuild
      npm run build --no-update-notifier --targets "ttf::$pname" -- --jCmd="$NIX_BUILD_CORES" --verbose=9
      npm run build --no-update-notifier --targets "woff2::$pname" -- --jCmd="$NIX_BUILD_CORES" --verbose=9
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      ttfontdir="$out/share/fonts/truetype"
      wfontdir="$out/share/fonts/woff2"
      install -d "$ttfontdir"
      install -d "$wfontdir"
      install "dist/$pname/TTF"/* "$ttfontdir"
      install "dist/$pname/WOFF2"/* "$wfontdir"
      runHook postInstall
    '';
  }
)
