{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #nix
    alejandra
    nil

    elixir
    elixir_ls

    nodejs
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    typescript
  ];
}