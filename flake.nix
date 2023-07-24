{
  description = "catppuccin/alacritty packaged for Nix consumption";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
  };

  outputs = inputs@{ self, flake-parts, catppuccin-alacritty, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      flake = {
        overlays.catppuccin-alacritty-theme = final: prev: {
          catppuccin-alacritty-theme = self.packages.${prev.system};
        };
        overlays.default = self.overlays.catppuccin-alacritty-theme;
      };
      systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
      perSystem = { lib, pkgs, ... }:
        let
          isYaml = file: lib.hasSuffix ".yaml" file || lib.hasSuffix ".yml" file;
          withoutYamlExtension = file: lib.removeSuffix ".yml" (lib.removeSuffix ".yaml" file);
          dirEntries = lib.attrNames (builtins.readDir "${catppuccin-alacritty}/");
          themeFiles = lib.filter isYaml dirEntries;
          mkThemePackage = themeFile:
            let
              name = withoutYamlExtension themeFile;
            in
            lib.nameValuePair name (pkgs.stdenvNoCC.mkDerivation {
              inherit name;
              dontUnpack = true;
              dontConfigure = true;
              dontBuild = true;
              installPhase = ''
                runHook preInstall
                cp --reflink=auto ${catppuccin-alacritty}/${themeFile} $out
                runHook postInstall
              '';
            });
          themeDerivations = map mkThemePackage themeFiles;
        in
        {
          packages = lib.listToAttrs themeDerivations;
        };
    };
}
