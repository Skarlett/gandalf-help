{ pkgs, lib, nix-colors, username, variables,...}:
let variables = builtins.fromJSON (builtins.readFile ./variables.json);
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ./development.nix
  ];

  home.packages = with pkgs; [
    fd
    file
    fzf
    zoxide
    broot
    direnv
    bat
    eza
    ripgrep
    lsof
    zip
    unzip
  ];

  colorScheme = let
    scheme = nix-colors.colorSchemes.gruvbox-dark-medium;
    hashedColors = lib.mapAttrs (_: color: "#${color}") scheme.colors;
  in
    scheme // { inherit hashedColors; };

  programs = {
    bat.enable = true;
    eza.enable = true;
    home-manager.enable = true;

    git = {
      enable = true;
      userName = variables.git.username;
      userEmail = variables.git.email;

      ignores = [ ".direnv/" ];

      # TODO: Figure out SSH vs GPG
      signing = {
        signByDefault = true;
        key = variables.git.signingKey;
      };

      extraConfig = {
        init.defaultBranch = "main";
        github.user = variables.github.username;
        tag.gpgSign = true;
        safe.directory = "*";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        bind -k nul -M insert 'accept-autosuggestion'
      '';
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        nix_shell = {
          symbol = " ";
          format = "[$symbol]($style) ";
        };
        hostname.format = "[$hostname]($style):";
        username.format = "[$user]($style)@";
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      fileWidgetOptions = ["--preview 'bat --color=always {}'"];
    };

    broot = {
      enable = true;
      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  services = {
      vscode-server.enable = true;
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
  };

  home.shellAliases = {
    ll = "eza -lFT --group-directories-first --color=always --git --git-ignore --level 1";
    lla = "eza -laTF --group-directories-first --color=always --git --level 1";
    llt = "eza -lTF --group-directories-first --color=always --git --git-ignore";
    llta = "eza -laTF --group-directories-first --color=always --git";
    cat = "bat";
  };

  home.stateVersion = "23.05";
}