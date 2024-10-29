{ pkgs, ... }:

{
  # TODO: Setup dotfiles
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

