{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11?shallow=1";
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
      gen = func: (genSystems (system: func (systemPkgs system)));
    in
    {
      packages = gen (pkgs: {
        default = pkgs.callPackage ./default.nix { };
        subset = pkgs.callPackage ./subset.nix {
          iosevka-lyte = inputs.self.packages.${pkgs.system}.default;
        };
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
