{ ... }:

let
  home-directory = "/home/logan";
in
{
  imports = [
    ./programs/firefox.nix
    ./programs/fzf.nix 
    ./programs/git.nix
    ./programs/hyprland.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/nix-search-cli.nix
    ./programs/nushell.nix
    ./programs/parsec.nix
    ./programs/ripgrep.nix
    ./programs/rofi-wayland.nix
    ./programs/tealdeer.nix
    ./programs/clang.nix
    ./programs/make.nix
  ];

  # TODO: Setup clipboard history

  stylix = {
    enable = true;
    autoEnable = true;

    targets.kde.enable = false; # if enabled, causes issues with neovim
    targets.nixvim.enable = false;
    targets.vim.enable = false;
  };

  home = {
    homeDirectory = "${home-directory}";

    # Do not change
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
