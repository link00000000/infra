{ pkgs, ... }:

{
  users.groups.admin = {};

  systemd.services."set-nixos-configuration-permissions" = {
    description = "Set permissions for /etc/nixos";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.coreutils}/bin/chmod -R u=rwx,g=rwx,o=rx /etc/nixos
      ${pkgs.acl}/bin/setfacl -d -m g:admin:rwx /etc/nixos
      ${pkgs.acl}/bin/setfacl -d -m u:root:rwx /etc/nixos
      ${pkgs.acl}/bin/setfacl -d -m o:rx /etc/nixos
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Required for xdg.portal.enable in home manager
  # https://github.com/nix-community/home-manager/blob/2f23fa308a7c067e52dfcc30a0758f47043ec176/modules/misc/xdg-portal.nix#L22
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
