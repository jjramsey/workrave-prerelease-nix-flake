{
  description = "Packaging for pre-release Workrave";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "flake-utils";  
  };

  outputs = {self, nixpkgs, flake-utils, ... } :
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};       
      in {
        packages = {
          workrave = pkgs.callPackage ./package.nix  { };
          default = self.packages.${system}.workrave;
        };
      });
}
