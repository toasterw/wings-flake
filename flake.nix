{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs }: {
          default = pkgs.buildGoModule rec {
            pname = "wings";
            version = "1.13.3";

            src = pkgs.fetchFromGitHub {
              owner = "pterodactyl";
              repo = "wings";
              rev = "v${version}";
              sha256 = "sha256-12nV7jFlVbjjZT3uFbYEhTyJcZe88FEQEguBkgcbHGI=";
            };
            vendorHash = "sha256-BtATik0egFk73SNhawbGnbuzjoZioGFWeA4gZOaofTI=";
          };
        }
      );
    };
}
