{ inputs, ... }:

let
  home-directory = "/home/logan";
in
{
  imports = [
    inputs.desktop-shell.homeManagerModules.default

    ./programs/zen-browser.nix
    ./programs/btop.nix
    ./programs/clang.nix
    ./programs/fzf.nix 
    ./programs/git.nix
    ./programs/hyprland.nix
    ./programs/hyprshot.nix
    ./programs/imhex.nix
    ./programs/kitty.nix
    ./programs/make.nix
    ./programs/nautilus.nix
    ./programs/neovim.nix
    ./programs/nix-search-cli.nix
    ./programs/nushell.nix
    ./programs/obsidian.nix
    ./programs/parsec.nix
    ./programs/pavucontrol.nix
    ./programs/prismlauncher.nix
    ./programs/qdirstat.nix
    ./programs/rbw.nix
    ./programs/ripgrep.nix
    ./programs/rofi-wayland.nix
    ./programs/syncthing.nix
    ./programs/tealdeer.nix
    ./programs/trayscale.nix
    ./programs/waybar.nix
    ./programs/wezterm.nix
    ./programs/xdg.nix
  ];

  # TODO: Setup clipboard history

  stylix = {
    enable = true;
    autoEnable = true;

    targets.kde.enable = false; # if enabled, causes issues with neovim
    targets.nixvim.enable = false;
    targets.neovim.enable = false;
    targets.vim.enable = false;
    targets.nushell.enable = false;
  };

  home = {
    homeDirectory = "${home-directory}";

    sessionVariables = {
      PAGER = "nvim +Man!";
      MANPAGER = "nvim +Man!";
    };

    # Do not change
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
  programs.desktop-shell.enable = false;
}
