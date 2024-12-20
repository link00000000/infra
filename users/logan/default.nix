{ pkgs, ... }:

let
  username = "logan";
in
{
  users.users.${username} = {
    name = username;
    home = "/home/logan";
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "admin" "wireshark" "docker" "vboxusers" ];
    shell = pkgs.nushell;
  };

  home-manager.users.${username} = import ./home.nix;
}
