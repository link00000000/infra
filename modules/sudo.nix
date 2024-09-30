{ pkgs, ... }:

{
  security.sudo.extraConfig = ''
    Defaults !always_set_home, !set_home
    Defaults env_keep+="HOME EDITOR VISUAL PATH"
  '';
}
