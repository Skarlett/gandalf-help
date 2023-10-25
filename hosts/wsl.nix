{ self, inputs, username, hostname, variables, modulesPath, ... }:
{
    imports = [
        "${modulesPath}/profiles/minimal.nix"
    ];

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [

            ({ lib, ... }: {
                options.colorScheme.hashedColors = with lib;
                    mkOption { type = types.attrsOf types.str; };
            })
        ];

        extraSpecialArgs = { inherit inputs username hostname variables; };

        users.${username}.imports = [
            ../user/base.nix
            ../user/development.nix
        ];
    };

    programs.fish.enable = true;
    wsl = {
        enable = true;
        wslConf.automount.root = "/mnt";
        defaultUser = username;
        startMenuLaunchers = true;
        nativeSystemd = true;
        # Enable native Docker support
        # docker-native.enable = true;
        # Enable integration with Docker Desktop (needs to be installed)
        docker-desktop.enable = true;
    };

    virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
    };

    services.vscode-server.enable = true;
    networking.hostName = hostname;
    system.stateVersion = "23.05";
}
