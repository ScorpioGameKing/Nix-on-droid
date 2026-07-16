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
  scorpio-gruv-dotfiles = pkgs.fetchFromGitHub {
    owner = "ScorpioGameKing";
    repo = "Scorpio-Gruv-dotfiles";
    rev = "c451f1caf28d4a268af0f44a7e77e889a64dedd0";
    sha256 = "sha256-8v87ydtUfCjSeje3+50bUBKIHl9bqf58aDLwJB4jtro=";
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

  # Fastfetch Settings
  xdg.configFile = {
    "fastfetch" = {
      source = config.lib.file.mkOutOfStoreSymlink "${scorpio-gruv-dotfiles}/.config/fastfetch";
      recursive = true;
    };
  };

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
    options = [
	"--cmd cd"
    ];
  };
  programs.fzf = {
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
