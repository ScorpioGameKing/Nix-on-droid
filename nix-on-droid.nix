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
    git      # Version Control
    ncurses  # Get Clear back
    killall  # Kill Processes
    hostname # Set/Change Host/Domain/etc
    man      # Read Man Pages
    bzip2    # Compression Tool
    gzip     # Compression Tool
    xz       # Compression Tool
    zip      # Compression Tool
    unzip    # Compression Tool
    fzf      # Command Line Fuzzy Finder
    zoxide   # Better CD
    eza      # Better LS
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
