{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
