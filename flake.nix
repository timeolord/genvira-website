{
  description = "local wordpress prototyping environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      for_each_system = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      devShells = for_each_system (pkgs:
        let
          wordpress = pkgs.wordpress.overrideAttrs (_: {
            installPhase = ''
              mkdir -p $out/share/wordpress
              cp -r . $out/share/wordpress
            '';
          });
          wp_dev = pkgs.writeScriptBin "wp_dev" ''
            #!${pkgs.fish}/bin/fish
            ${builtins.readFile ./scripts/wp_dev.fish}
          '';
        in {
          default = pkgs.mkShell {
            packages = [ pkgs.php pkgs.mariadb pkgs.wp-cli pkgs.coreutils wp_dev ];
            WP_DEV_SOURCE = "${wordpress}/share/wordpress";
            WP_DEV_CONFIG = toString ./scripts/wp-config.php;
            WP_DEV_ROUTER = toString ./scripts/router.php;
          };
        });
    };
}
