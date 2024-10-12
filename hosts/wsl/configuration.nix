{ config, lib, pkgs, ... }:

{
  imports = [
    ../../system/locale.nix
    ../../system/nix.nix
    ../../system/nixos.nix
    ../../system/sudo.nix
    ../../system/utils.nix

    ../../users/logan
  ];

  environment.sessionVariables.BROWSER = "explorer.exe";

  programs.wireshark.enable = true;

  # WSL
  wsl.enable = true;
  wsl.defaultUser = "logan";

  # Networking
  networking.hostName = "wsl";

  # Do not change
  system.stateVersion = "23.11";
}
