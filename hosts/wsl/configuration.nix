{ pkgs, ... }:

{
  imports = [
    ../../system/locale.nix
    ../../system/nix.nix
    ../../system/nixos.nix
    ../../system/sudo.nix
    ../../system/utils.nix

    ../../themes/tokyonight.nix

    ../../users/logan
  ];

  environment.sessionVariables.BROWSER = "explorer.exe";

  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [
    gh
  ];

  # WSL
  wsl.enable = true;
  wsl.defaultUser = "logan";
  wsl.docker.enable = true;

  # Networking
  networking.hostName = "wsl";

  # Do not change
  system.stateVersion = "23.11";
}
