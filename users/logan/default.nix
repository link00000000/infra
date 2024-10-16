{ pkgs, ... }@inputs:

let
  username = "logan";

in
{
  imports = [
    #./theme.nix
    ../../system/modules/wireshark.nix
  ];

  users.users.${username} = {
    name = username;
    home = "/home/logan";
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "admin" "wireshark" ];
    shell = pkgs.nushell;
  };

  home-manager.users.${username} = import ./home.nix;
}
