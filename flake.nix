{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    {
      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          (
            { pkgs, ... }:
            {
              imports = [
                ./disk-config.nix
              ];

              boot.initrd.systemd.enable = true;
              boot.loader.systemd-boot.enable = true;

              environment.systemPackages = map pkgs.lib.lowPrio [
                pkgs.curl
                pkgs.gitMinimal
              ];

              programs.zsh.enable = true;

              services.openssh.enable = true;

              users.users.bob = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
                shell = pkgs.zsh;
              };

              users.users.root.openssh.authorizedKeys.keyFiles = [
                ./id_rsa.pub
              ];

              system.stateVersion = "24.11";

              systemd.sleep.extraConfig = ''
                HibernateDelaySec=7200
              '';
            }
          )
          nixos-facter-modules.nixosModules.facter
          {
            config.facter.reportPath =
              if builtins.pathExists ./facter.json then
                ./facter.json
              else
                throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
          }
        ];
      };
    };
}
