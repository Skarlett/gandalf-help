{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #nix
    alejandra
    nil

    elixir
    ###
    # broken package
    # elixir_ls
    ###
    nodejs
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    typescript
  ];
}
