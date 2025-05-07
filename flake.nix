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
      });
    };
}
