{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}
