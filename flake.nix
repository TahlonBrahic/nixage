{
  description = "Age fork with additional functionality built-in for Nix";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    legacyPackages = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.callPackage ./default.nix {inherit pkgs;});
    packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
    defaultPackage = forAllSystems (system: self.packages.${system}.out);
  };
}
