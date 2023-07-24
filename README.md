# catppuccin-alacritty-theme.nix

This repo packages all of the themes available at [catppuccin/alacritty](https://github.com/catppuccin/alacritty)
as individual flake outputs for easy use in your nix-managed Alacritty config.

This repository and its flake are based on the great [alexghr/alacritty-theme.nix](https://github.com/alexghr/alacritty-theme.nix).

## Outputs

Each YAML file in the [catppuccin/alacritty](https://github.com/catppuccin/alacritty) repo is exported as a package.

Furthermore an overlay is provided that groups all of these themes under a single attribute set: `pkgs.catppuccin-alacritty-theme`.

## Apply a color scheme using home-manager

This sample config applies the overlay and configures `catppuccin-mocha` as the color scheme for Alacritty using home-manager.

You can read more about installing overlays with Flakes [on NixOS Wiki](https://nixos.wiki/wiki/Flakes#Importing_packages_from_multiple_channels).

```nix
# flake.nix
{
  inputs.catppuccin-alacritty-theme.url = "github:ohlus/catppuccin-alacritty-theme.nix";
  outputs = { nixpkgs, catppuccin-alacritty-theme, ... }: {
    nixosConfigurations.yourComputer =  nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ...}: {
          # install the overlay
          nixpkgs.overlays = [ catppuccin-alacritty-theme.overlays.default ];
        })
        ({ config, pkgs, ... }: {
          home-manager.users.you = hm: {
            programs.alacritty = {
              enable = true;
              # use a color scheme from the overlay
              settings.import = [ pkgs.catppuccin-alacritty-theme.catppuccin-mocha ];
            };
          };
        })
      ];
    };
  };
}
```

That's it :smile:
