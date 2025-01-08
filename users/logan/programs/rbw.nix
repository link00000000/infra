{ pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vaultwarden.accidentallycoded.com";
      email = "logan@accidentallycoded.com";
      pinentry = pkgs.pinentry-curses;
    };
  };
}
