{ ... }:

{
  # TODO: Setup copying config
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "link00000000";
    userEmail = "crandall.logan@gmail.com";
    aliases = {
      ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
    };
    extraConfig = {
      safe.directory = [ "/etc/nixos" ];
    };
  };

  programs.lazygit.enable = true;
}
