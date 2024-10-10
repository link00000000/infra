{ pkgs, ... }:

{
  # TODO: Setup copying config
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    # Language Servers
    nil
  ];
}

