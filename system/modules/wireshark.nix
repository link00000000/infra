{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wireshark # Required even through the program is enabled throught programs.*
  ];

  programs.wireshark.enable = true;
}
