{ pkgs, pkgs-unstable, ... }:

{
  # TODO: Setup dotfiles
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Language servers
      nil
      clang-tools
      gopls
      vscode-langservers-extracted
      nodePackages.typescript-language-server
    ];
  };
}

