{ pkgs, ... }:

{
  imports = [
    ./firefox
    ./fzf
    ./git
    ./hyprland
    ./hyprpaper
    ./kitty
    ./neovim
    ./nix-search-cli
    ./nushell
    ./parsec
    ./ripgrep
    ./rofi-wayland
    ./tealdeer
    ./wireshark
  ];

  # TODO: Setup clipboard history

  home = {
    homeDirectory = "/home/logan";

    # Do not change
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  home.packages = [ pkgs.kitty ];
}
