{ pkgs, ... }:

{
  users.groups.admin = {};

  systemd.services."set-nixos-configuration-permissions" = {
    description = "Set permissions for /etc/nixos";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.coreutils}/bin/chown -R root:admin /etc/nixos
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
}
