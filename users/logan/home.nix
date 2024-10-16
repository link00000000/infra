{ pkgs, ... }:

let
  home-directory = "/home/logan";

in
{
  imports = [
    ./programs/firefox.nix
    ./programs/fzf.nix 
    ./programs/git.nix
    ./programs/hyprland
    ./programs/hyprpaper.nix
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

  home = {
    homeDirectory = "${home-directory}";

    # Do not change
    stateVersion = "24.05";
  };

#  systemd.user.services."clone-dotfiles" = {
#    description = "Clone dotfiles repo to ~/.dotfiles";
#    wantedBy = [ "multi-user.target" ];
#    script = ''
#      if [ ! -d ${home-directory}/.dotfiles ]; then
#        ${pkgs.git}/bin/git git clone git@github.com:link00000000/dotfiles ${home-directory}/.dotfiles
#      fi
#    '';
#    serviceConfig = {
#      Type = "oneshot";
#    };
#  };

  programs.home-manager.enable = true;
}
