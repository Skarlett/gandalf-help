inputs @ { self, nixpkgs, nixos-wsl, nix-colors, home-manager, vscode-server, username, hostname, system, ... }:
{
  nixos-wsl = nixpkgs.lib.nixosSystem {
    specialArgs = inputs;

    inherit system;

    modules = [
        { config._module.args = { inherit nixpkgs; }; }
        ../system/base.nix
        home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              nix-colors.homeManagerModules.default
              ({ lib, ... }: { options.colorScheme.hashedColors = with lib; mkOption { type = types.attrsOf types.str; }; })
            ];
            extraSpecialArgs = { inherit nix-colors; };
          };
        }
        ./wsl.nix
        nixos-wsl.nixosModules.wsl
        vscode-server.nixosModules.default
        {
          home-manager.users.${username}.imports = [
            ../user/base.nix
            ../user/development.nix
          ];
        }
    ];
  };
}