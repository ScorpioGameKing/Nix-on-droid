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

  # ---------------------------
  # User Package Configurations
  # ---------------------------

  # Home Manager Settings
  programs.home-manager = {
    enable = true;
  };

  # Bash Settings
  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      grep = "grep --color=auto";
      ls = "eza -TF -L 1 -a -s type --icons=auto -lUmh --git-repos --no-permissions";
      ff = "clear && fastfetch";
      vi = "nvim";
      nodsw = "nix-on-droid switch --flake ~/.config/nix-on-droid/";
      nodswc = "unlink ~/.bashrc && nix-collect-garbage -d && nix-on-droid switch --flake ~/.config/nix-on-droid/";
    };
    nodrl = "nix-on-droid rollback";
    initExtra = ''
      ff
    '';
  };

  /*
  # For some reason nix-on-droid's
  # home-manager instance can't find
  # fastfetch. Feels similar to the
  # Yazi flavor issues and is just a
  # nix-on-droid issue.

  # Fastfetch Settings
  programs.fastfetch = {
    enable = true;
  };
  */

  # Yazi Settings
  programs.yazi = {
    enable = true;
    enableBashIntegration = true; # Adds drop into support through ya alias
    settings = {
      manager = {
          show_hidden = true;
          ratio = [
            1
            4
            3
          ];
          sort_by = "alphabetical";
          sort_dir_first = true;
          linemode = "size";
      };
      preview = {
        wrap = "yes";
      };
      opener = {
        edit = [
            {
            run = "nvim \"$@\"";
            block = true;
            for = "unix";
            }
        ];
      };
    };
  };
  
  # Zoxide settings
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  
  # -------------------------------
  # Handwritten scripts and Configs
  # -------------------------------
  
  /*
  # Quick Switch Script
  home.file."nix-switch.sh".text = ''
    #!/usr/bin/env bash
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';

  # Clean and Switch Script
  home.file."nix-clean-switch.sh".text = ''
    #!/usr/bin/env bash
    unlink .bashrc
    nix-collect-garbage -d
    nix-on-droid switch --flake ~/.config/nix-on-droid/
  '';
  */
}
