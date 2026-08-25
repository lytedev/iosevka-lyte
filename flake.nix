{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs =
    inputs:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      genSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
      systemPkgs = system: (import inputs.nixpkgs { inherit system; });
    in
    let
      # fonts are platform-independent, so build once on x86_64-linux and reuse everywhere
      buildPkgs = systemPkgs "x86_64-linux";
      font = buildPkgs.callPackage ./default.nix { };
      subset = buildPkgs.callPackage ./subset.nix { iosevka-lyte = font; };
    in
    {
      packages = genSystems (_: {
        default = font;
        inherit subset;
      });
    };

  nixConfig = {
    extra-substituters = [
      "https://nix.h.lyte.dev"
      "https://iosevka-lyte.cachix.org"
    ];
    extra-trusted-public-keys = [
      "h.lyte.dev-2:te9xK/GcWPA/5aXav8+e5RHImKYMug8hIIbhHsKPN0M="
      "iosevka-lyte.cachix.org-1:5pX+LwVdlfWJtmubPErASJecnm1q3a/RoZmah1GU+FM="
    ];
  };
}
