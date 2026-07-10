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
    pkgs.fastfetch
    pkgs.neovim
    pkgs.yazi
    pkgs.lazygit
    pkgs.gh
  ];

  # Home Manager Settings
  programs.home-manager = {
    enable = true;
  };

  # Bash Settings
  programs.bash = {
    enable = true;
  };

  # Handwritten scripts and Configs
  home.file."nix-switch.sh".text = ''
    #!/usr/bin/env bash
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';
}
