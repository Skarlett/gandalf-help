{ self, username, hostname, variables, inputs, ... }:
{
  nixos-wsl = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self username hostname variables;
      inherit (self) inputs;
    };
    system = "x86_64-linux";
    modules = [
        ../system/base.nix
        ./wsl.nix
        inputs.home-manager.nixosModules.default
        inputs.nixos-wsl.nixosModules.wsl
        inputs.vscode-server.nixosModules.default
    ];
  };
}
