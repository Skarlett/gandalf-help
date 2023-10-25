{ inputs, pkgs, username, variables, ... }:
{
  time.timeZone = variables.region.timezone or "UTC";
  i18n.defaultLocale = variables.region.locale or "en_US.UTF-8";

  environment = {
    systemPackages = with pkgs; [
      git
      curl
      wget
      fish
      vim
      neovim
      nerdfonts
    ];
  };

  services = {
    openssh = {
      enable = true;

    #   settings = {
    #     PasswordAuthentication = false;
    #   };

    #   hostKeys = [{
    #     # path = ;
    #     type = "ed25519";
    #   }];
    # };

    # tailscale.enable = true;
    };
  };

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" /* "FiraCode" "FiraMono" */ ]; })
    ];
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.fish;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      flakes.to = {
        owner = variables.github.username;
        repo = "flakes";
        type = "github";
      };
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      accept-flake-config = true;
    };
  };

  documentation = {
    enable = true;
    nixos.enable = true;
    man.enable = true;
    dev.enable = true;
  };
}
