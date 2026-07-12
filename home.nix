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

# Grab Dotfiles
let
  scorpio-gruvy-dotfiles = pkgs.fetchFromGitHub {
    owner = "scorpiogk";
    repo = "https://github.com/ScorpioGameKing/Scorpio-Gruv-dotfiles.git";
    rev = "master";
    sha256 = "1nrpj6k1a39hrhnzyhkd0wxmi1j9qlwn0bz2g6rlzk35pqgx0nmn";
  };
in

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

  home.activation = {
    copyFont = let
      font_src ="${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/AgaveNerdFontMono-Regular.ttf";
      font_dst = "${config.home.homeDirectory}/.termux/font.ttf";
      in lib.hm.dag.entryAfter ["writeBoundary"] ''
        ( test ! -e "${font_dst}" || test $(sha1sum "${font_src}"|cut -d' ' -f1 ) != $(sha1sum "${font_dst}" |cut -d' ' -f1)) && $DRY_RUN_CMD install $VERBOSE_ARG -D "${font_src}" "${font_dst}"
	echo "${scorpio-gruvy-dotfiles}"
    '';
  };

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
      lzg = "lazygit";
      nodsw = "nix-on-droid switch --flake ~/.config/nix-on-droid/";
      nodswc = "cd ~ && unlink .bashrc && nix-collect-garbage -d && nix-on-droid switch --flake ~/.config/nix-on-droid/";
      nodrl = "nix-on-droid rollback";
    };
    initExtra = ''
      ff
    '';
  };

  
  # For some reason nix-on-droid's
  # home-manager instance can't find
  # fastfetch. Feels similar to the
  # Yazi flavor issues and is just a
  # nix-on-droid issue. From searches
  # it appears fastfetch's declarative
  # config was added 24.11, this is 
  # 24.05. Instead copy the source from
  # existing dotfile repo.

  # Fastfetch Settings

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
  # Currently seems to not be working
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
