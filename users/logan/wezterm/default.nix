{ pkgs, inputs, ... }:

{
  # TODO: Setup copying wezterm config
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
  };
}
