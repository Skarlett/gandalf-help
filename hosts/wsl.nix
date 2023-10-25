{ self, nixpkgs, nixos-wsl, nix-colors, home-manager, vscode-server, username, hostname, modulesPath, ... }:
{
    imports = [
        "${modulesPath}/profiles/minimal.nix"
        self.inputs.vscode-server.nixosModules.default
    ];

    wsl = {
        enable = true;
        wslConf.automount.root = "/mnt";
        defaultUser = username;
        startMenuLaunchers = true;
        nativeSystemd = true;
        # Enable native Docker support
        docker-native.enable = true;
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