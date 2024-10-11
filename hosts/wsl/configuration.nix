{ config, lib, pkgs, ... }:

{
  imports = [
    ../../system/modules/locale.nix
    ../../system/modules/nix.nix
    ../../system/modules/nixos.nix
    ../../system/modules/sudo.nix
    ../../system/modules/utils.nix

    ../../users/logan
  ];

  environment.sessionVariables.BROWSER = "explorer.exe";

  # WSL
  wsl.enable = true;
  wsl.defaultUser = "logan";

  # Networking
  networking.hostName = "wsl";

  # Do not change
  system.stateVersion = "23.11";
}
