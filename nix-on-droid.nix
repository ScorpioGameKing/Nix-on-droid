# -----------------------------
# Nix/Nix-On-Droid Settings
# -----------------------------
# Used for installing and
# managing core system programs
# and settings. For User 
# oriented settings see 
# 'home.nix' for Home Manager
# configuration
# -----------------------------

{ config, lib, pkgs, ... }:

{
  # Install System Packages
  environment.packages = with pkgs; [
    git
    killall
    hostname
    man
    bzip2
    gzip
    xz
    zip
    unzip
    fzf
    zoxide
    eza
  ];

  # Nix Settings
  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Enable Home Manager Configuration
  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    config = ./home.nix;
    };
}
