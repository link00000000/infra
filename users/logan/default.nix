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
    extraGroups = [ "wheel" "admin" "wireshark" ];
    shell = pkgs.bash;
  };

  home-manager.users.${username} = import ./home.nix;
}
