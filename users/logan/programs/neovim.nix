{ pkgs, inputs, ... }:

{
  # TODO: Setup dotfiles
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Language servers
      nil
      clang-tools
      gopls
      vscode-langservers-extracted
      nodePackages.typescript-language-server
      lua-language-server
    ];
  };
}

