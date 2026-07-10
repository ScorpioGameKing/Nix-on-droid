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
  };

  #Yazi Settings
  programs.yazi = {
    enable = true;
    enableBashIntegration = true; # Adds drop into support through ya alias
  };

  # -------------------------------
  # Handwritten scripts and Configs
  # -------------------------------

  # Quick Switch Script
  home.file."nix-switch.sh".text = ''
    #!/usr/bin/env bash
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';

  # Clean and Switch Script
  home.file."nix-clean-switch.sh".text = ''
    #!/usr/bin/env bash
    unlink .bashrc
    nix-garbage-collect -d
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';
}
