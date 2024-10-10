{ ... }:

{
  imports = [
    ./firefox
    ./git
    ./hyprland
    ./nix-search-cli
    ./parsec
    ./wireshark
    ./ripgrep
    ./neovim
    ./nushell
    ./wezterm
    ./tealdeer
    ./fzf
    ./rofi-wayland
    ./hyprpaper
  ];

  # TODO: Setup clipboard history

  home = {
    homeDirectory = "/home/logan";

    # Do not change
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
