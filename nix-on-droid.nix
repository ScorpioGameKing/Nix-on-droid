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

let
  sshdTmpDirectory = "${config.user.home}/sshd-tmp";
  sshdDirectory = "${config.user.home}/sshd";
  pathToPubKey = "...";
  port = 8022;
in

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
    ripgrep  # Grep go BRRRR
    openssh  # Connect me
    (pkgs.writeScriptBin "sshd-start" ''
      #!${pkgs.runtimeShell}

      echo "Starting sshd in non-daemonized way on port ${toString port}"
      ${pkgs.openssh}/bin/sshd -f "${sshdDirectory}/sshd_config" -D
    '')
  ];

  # Nix Settings
  environment.etcBackupExtension = ".bak";
  system.stateVersion = "24.05";
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  build.activation.sshd = ''
    $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"
    $DRY_RUN_CMD cat ${pathToPubKey} > "${config.user.home}/.ssh/authorized_keys"

    if [[ ! -d "${sshdDirectory}" ]]; then
      $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

      $VERBOSE_ECHO "Generating host keys..."
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

      $VERBOSE_ECHO "Writing sshd_config..."
      $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort ${toString port}\n" > "${sshdTmpDirectory}/sshd_config"

      $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
    fi
  '';
  # Enable Home Manager Configuration
  home-manager = {
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    config = ./home.nix;
    };
}
