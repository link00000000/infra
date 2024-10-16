{ pkgs, username, ... }:

{
#  systemd.user.services."setup-neovim-dotfiles" = {
#    description = "Setup symlink to dotfiles for Neovim";
#    wantedBy = [ "multi-user.target" ];
#    script = ''
#      if [ ! -d /home/logan/.config/nvim ]; then
#        ${pkgs.busybox}/bin/ln -s /home/logan/.dotfiles/vim/nvim-lean /home/logan/.config/nvim
#      fi
#    '';
#    serviceConfig = {
#      Type = "oneshot";
#      User = "${username}";
#    };
#  };

  # TODO: Setup copying config
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Language servers
      nil
      clang-tools
      gopls
    ];
  };
}

