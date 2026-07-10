# -------------------------------
# Home Manager Configuration
# -------------------------------
# Used to setup user oriented 
# packages and configurations
# as an alternative to a classic
# dotfiles approach. For system
# packages see 'nix-on-droid.nix'
# -------------------------------

{config, lib, pkgs, ... }:

{
  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  # User Packages
  home.packages = [
    pkgs.fastfetch # Pretty System Post
    pkgs.neovim    # Better Text Editor
    pkgs.yazi      # Terminal File Browser
    pkgs.lazygit   # Git Repo Management
    pkgs.gh        # Github CLI 
  ];

  # Home Manager Settings
  programs.home-manager = {
    enable = true;
  };

  # Bash Settings
  programs.bash = {
    enable = true;
    initExtra = ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }
    '';
  };

  # Handwritten scripts and Configs
  home.file."nix-switch.sh".text = ''
    #!/usr/bin/env bash
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';
}
