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
          php = pkgs.php84;
          wp_cli = pkgs.wp-cli.override { inherit php; };
          wordpress = pkgs.wordpress.overrideAttrs (_: {
            installPhase = ''
              mkdir -p $out/share/wordpress
              cp -r . $out/share/wordpress
            '';
          });
          wp_dev = pkgs.writeScriptBin "wp_dev" ''
            #!${pkgs.fish}/bin/fish
            ${builtins.readFile ./scripts/snapshot.fish}
            ${builtins.readFile ./scripts/wp_dev.fish}
          '';
        in {
          default = pkgs.mkShell {
            packages = [ php pkgs.mariadb wp_cli pkgs.coreutils pkgs.fish wp_dev ];
            WP_DEV_SOURCE = "${wordpress}/share/wordpress";
            WP_DEV_CONFIG = "${./scripts/wp-config.php}";
            WP_DEV_ROUTER = "${./scripts/router.php}";
            WP_DEV_SANITIZER = "${./scripts/sanitize-snapshot.sql}";
            WP_DEV_PROTOTYPE = "${./scripts/setup-prototype.php}";
            WP_DEV_EXPORT = "${./scripts/export-static.php}";
          };
          qa = pkgs.mkShell {
            packages = [ pkgs.nodejs pkgs.chromium pkgs.actionlint pkgs.fish ];
          };
        });
    };
}
