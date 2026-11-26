{
  description = "genvira static website";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      for_each_system = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = for_each_system (pkgs:
        {
          default = pkgs.mkShell {
            packages = [ pkgs.zola pkgs.nodejs pkgs.fish ];
          };
          qa = pkgs.mkShell {
            packages = [ pkgs.nodejs pkgs.chromium pkgs.actionlint pkgs.fish ];
          };
          fonts = pkgs.mkShell {
            packages = [ (pkgs.python3.withPackages (ps: [ ps.fonttools ])) ];
          };
        });
    };
}
