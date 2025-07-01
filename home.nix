{
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  inputs,
  outputs,
  config,
  customNeovim,
  ...
}: let
  homeManagerDirectory = "${config.home.homeDirectory}/.config/home-manager";
  systemSpecificPackages = {
    aarch64-darwin = with pkgs; [
      iterm2
      arc-browser
    ];
  };
  tmuxConfFile = "${config.xdg.configHome}/tmux/tmux.conf";
  tmuxExtraConfFile = "${config.xdg.configHome}/tmux/extra.conf";
in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = true; # allow hell
      permittedInsecurePackages = [
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
      ];
    };
  };

  imports = [
    # inputs.nixvim.homeManagerModules.nixvim
    # ./modules/nixvim.nix
    ./modules/vscode.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "michaelmongelli";
  home.homeDirectory = "/Users/michaelmongelli";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = let
    zen-browser = import ./packages/zen-browser/default.nix {
      inherit (pkgs) lib fetchurl stdenvNoCC appimageTools undmg;
    };
  in
    with pkgs;
      [
        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        customNeovim.neovim
        zen-browser

        ## cli tools ##
        # neofetch # RIP
        trash-cli
        # ripgrep # needed for telescope.nvim
        zsh-powerlevel10k
        nixfmt-rfc-style
        nix-tree
        nix-output-monitor # <nix command> |& nom # shows build process with some style, used in `switch` shell alias
        # cached-nix-shell
        ollama
        nixd
        duf
        # rust-analyzer
        # devenv
        # wakatime
        # imagemagick # convert image formats on the command line
        # sqlite-web # view SQLite database in web browser
        # open-webui
        # devenv
        # cachix

        ## window management ##
        # yabai
        # skhd

        ## applications ##

        kitty
        sqlitebrowser
        # emacs # emacsMacport
        utm
        cinny-desktop
        obsidian
        spotify
        # teams
        discord
        dolphin-emu
        # rustdesk
        # qbittorrent
        # code-cursor
        # ungoogled-chromium
        # kicad
        # code-cursor # not available on MacOS
        # darwin.xcode
        # darwin.xcode_9_4_1
        # element-desktop
        # ladybird
        # thunderbird
        # nyxt

        ## languages ##

        # haskellPackages.hell
        # rustc
        # rustup
        # cargo # included in rustup
        # python312Packages.python
        # python312Packages.pip
        # python314
        # ghc
        # stack
        # cabal-install
        # nodejs_22
        # nodePackages.ts-node
        # deno
        # nodemon

        ## fonts ##

        nerd-fonts.fira-code
        meslo-lgs-nf
        hasklig
        nerd-fonts.hasklug
        nerd-fonts.monoid
        borg-sans-mono
        # iosevka
        nerd-fonts.zed-mono
        mononoki

        # TODO: to try in the future
        # virtualbox            # not available on MacOS
        # devbox                # wasn't a fan but might try again in the future
        # haskellPackages.hell  # broken package, debug it?
        haskell-language-server

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ]
      ++ (with pkgs-stable; [wireshark])
      ++ systemSpecificPackages.${system};

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = let
    # dotfilesDirectory = "~/.config/home-manager/dotfiles";
    dotfilesDirectory = "${homeManagerDirectory}/dotfiles";

    # Ensure each config file is present at its source path specified below.
    # Home Manager will create/update the file in your home directory upon `home-manager switch`.

    nixStoreDotfiles =
      [
        # ".config/kitty/"
        # ".ghc/ghci.conf"
        # ".config/skhd/skhdrc"
        # ".config/yabai/yabairc"
        # ".config/bat/config"
        ".bash_completion" # tmux autocomplete for bash
      ]
      |> map (dotfile: {
        name = dotfile;
        value = {
          source = ./dotfiles/${dotfile};
          recursive = true;
          onChange = "echo 'Changes detected in dotfile ${dotfile}'";
        };
      })
      |> builtins.listToAttrs;

    outOfStoreDotfiles =
      [
        ".p10k.zsh"
        ".config/kitty/"
        ".config/ghostty/"
        ".ghc/ghci.conf"
      ]
      |> map (dotfile: {
        name = dotfile;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/${dotfile}";
        };
      })
      |> builtins.listToAttrs;
    # {
    #   ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink p10k-config-file;
    #   ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink /Users/michaelmongelli/.config/home-manager/dotfiles/.config/kitty/kitty.conf;
    # ".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${home.homeDirectory}/.config/home-manager/dotfiles/.config/zed/settings.json";
    # };
  in
    nixStoreDotfiles // outOfStoreDotfiles;

  /*
  let
    p10k = ".p10k.zsh";
    ghci = ".ghc/ghci.conf";
  in {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ${p10k}.source = ./dotfiles/${p10k};
    ${ghci}.source = ./dotfiles/${ghci};
  };
  */

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/michaelmongelli/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = "nvim";
    HOME_MANAGER_DIR = builtins.toString homeManagerDirectory;
    # BAT_THEME = "gruvbox-dark";
    # BAT_PAGING = "never";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      themes.monokai = {
        fg = "#cecec3";
        bg = "#212121";
        black = "#212121";
        red = "#FC1A70";
        green = "#A4E400";
        yellow = "#ffff87";
        blue = "#af87ff";
        magenta = "#FC1A70";
        cyan = "#62D8F1";
        white = "#f7f7f0";
        orange = "#FF9700";
      };
      theme = "monokai";
    };
  };

  programs.tmux = {
    enable = true;
    # sensibleOnTop = true; # unable to set tmux default shell with sensible enabled
    terminal = "screen-256color";
    shell = "$SHELL";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1' # minutes
        '';
      }
    ];
    extraConfig = ''
      set -g mouse on
      set -g status-left-length 30
      set -g status-right-length 50

      set -g status-interval 1
      set -g status-right '#H %Y-%m-%dT%H:%M:%S'

      bind r source-file "${tmuxConfFile}" \; display-message "tmux config reloaded"

      # dynamically update tmux via extra config file
      if-shell "[ -f ${tmuxExtraConfFile} ]" {
        source-file "${tmuxExtraConfFile}"
      }
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # silent = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
    # stdlib = ''
    #   echo "activating direnv"
    # '';
  };

  programs.zed-editor = {
    enable = true;
    # .config/zed/settings.json
    userSettings = {
      "theme" = "VScode Dark Plus";
      "format_on_save" = "on";
      "ui_font_family" = "Inconsolata";
      "buffer_font_family" = "FiraCode Nerd Font";
      "tab_size" = 2;
      "ui_font_size" = 16;
      "buffer_font_size" = 16;
      "outline_panel" = {
        "dock" = "right";
      };
      "project_panel" = {
        "dock" = "right";
      };
      "load_direnv" = "direct";
      "vim_mode" = true;
      "terminal" = {
        "font_family" = "FiraCode Nerd Font";
        "blinking" = "on";
        "working_directory" = "current_project_directory";
      };
    };
    extensions = [
      "nix"
      "Catppuccin Blur"
    ];
    extraPackages = [pkgs.nixd];
  };

  # programs.neovide = {
  #   enable = true;
  #   # empty attrset needs to be supplied for default settings
  #   settings = {};
  #   /* settings = {
  #     fork = false;
  #     frame = "full";
  #     idle = true;
  #     maximized = false;
  #     no-multigrid = false;
  #     srgb = false;
  #     tabs = true;
  #     theme = "auto";
  #     title-hidden = true;
  #
  #     font = {
  #       normal = [];
  #       size = 14.0;
  #     };
  #   }; */
  # };

  programs.fastfetch.enable = true;

  # programs.fish.enable = true;

  # programs.oh-my-posh = {
  #   enable = true;
  #   useTheme = "gruvbox"; # "zash";
  # };

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    # zsh integration just enables the following aliases:
    # ls = "eza"
    # ll = "eza -l"
    # la = "eza -a"
    # lt = "eza --tree"
    # lla = "eza -la"
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      paging = "never";
      theme = "gruvbox-dark";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = pkgs.lib.importTOML ./dotfiles/.config/starship.toml;
  };

  programs.jq.enable = true;

  programs.htop.enable = true;

  programs.bottom = {
    enable = true;
    settings.flags.rate = "250ms";
    settings.flags.tree = true;
    settings.flags.temperature_type = "fahrenheit";
    settings.styles.theme = "gruvbox";
  };

  # programs.ghostty.enable = true;

  # enable and integrate with command-not-found
  # programs.nix-index.enable = true;

  programs.ripgrep.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;

    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo" # double tap ESC to rerun a command with sudo
        # "copypath" # copy current working directory to clipboard with ^O
        "copyfile" # copy contents of file to clipboard
        # "copybuffer" # copy command line buffer to clipboard
        "magic-enter" # execute `git status` when hitting ENTER in a git repo
      ];
      # theme = "wezm";
    };

    plugins = [
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.zsh-powerlevel10k;
      #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
    ];

    initExtra = ''
      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
      # Idk how but `p10k configure` does modify the home-manager p10k dotfile
      # even thouhg POWERLEVEL9K_CONFIG_FILE is not set because `source ~/.p10k.zsh` after hm-session-vars.sh
      # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # UNCOMMENT ME TO ENABLE YOUR P10K THEME
      # source ~/.p10k.zsh

      # Run this command in your terminal to add Homebrew to your PATH:
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # ohmyzsh magic-enter config
      MAGIC_ENTER_GIT_COMMAND='git status'
      MAGIC_ENTER_OTHER_COMMAND='la'

      # colored man pages
      export PAGER="less"
      export GROFF_NO_SGR=1
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'

      # sudo kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' \
      # /Users/michaelmongelli/.config/home-manager/dotfiles/.config/kitty/kitty.app.png \
      # /nix/store/30cxyaqkw63q7zwlqyqhzgn6lg8ji28b-kitty-0.37.0/Applications/kitty.app

      ## custom utility functions ##

      search-git-log () {
         git log --diff-filter=A -- ''${$1}
      }

      # TODO: find a better way to alert that home manager rebuild completed with success/failure
      saybg() {
        (set +m; say "$1" > /dev/null 2>&1 &) 2>/dev/null
      }

      # sshfs mount template
      # sudo diskutil umount force <username>@<ip>

      # sshfs unmount template
      # sshfs <username>@<ip>:/ <username>@<ip>  -o reconnect,volname=<username>,allow_other

      # enable dark mode for ChatGPT desktop app when OS is in dark mode
      # defaults write com.openai.chat NSRequiresAquaSystemAppearance -bool no
    '';

    shellAliases = {
      # eza
      ls = "eza -lh --time-style long-iso --git-repos -TL 1";
      ll = "eza -lh --time-style long-iso --git-repos";
      la = "eza -lah --time-style long-iso --git-repos -TL 1";
      lt = "eza -lh --time-style long-iso --git-repos -TL";
      lat = "eza -lah --time-style long-iso --git-repos -TL";
      las = "eza -lah --time-style long-iso --git-repos --total-size -TL 1";

      # make sure nix-output-monitor is installed for `nom`
      "sw" = ''
        if home-manager switch |& nom; then
          # saybg 'rebuild complete'
          tmux source ${tmuxConfFile}
          exec $SHELL
        else
          # saybg 'rebuild failed'
        fi
      '';
      "conf" = "${home.sessionVariables.EDITOR} ${homeManagerDirectory}";
      "gg" = ''
        git log --graph --decorate --color --format="%C(auto)%h%Creset %C(bold blue)%ad%Creset %C(auto)%d%Creset %s" --date=iso $(git rev-list -g --all)
      ''; # git graph
      "git-count-lines" = "git ls-files | xargs wc -l";
      # "git-log-search" = "search-git-log";
      "nix-shell-init" = "curl -O https://gist.githubusercontent.com/MMongelli99/af848753e3445e35534932c44e1cb9e7/raw/ef8dd127fec5a2e7bc5eed61e9a35d768b18010e/shell.nix";
      "devenv-init" = "curl -O https://gist.githubusercontent.com/MMongelli99/b2cd34eacfe3ef0f8fd6439afa8c38e3/raw/3716f3324b74083dcfa4c2e2fee29c12956a63be/flake.nix";
      "ai" = "ollama serve & ollama run llama3.1";
      "ip" = "ipconfig getifaddr en0";
      # "vscat" = "bat -pP --theme='Visual Studio Dark+'";
      # "bat" = "bat -pP --theme='gruvbox-dark'";
      "sshk" = "kitty +kitten ssh";
      "Wireshark" = "sudo '${home.homeDirectory}/Applications/Home Manager Apps/Wireshark.app/Contents/MacOS/Wireshark'";
      "scp-nonstrict" = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
    };
  };

  programs.git = {
    enable = true;
    userName = "Michael Mongelli";
    userEmail = "mmongelli99@gmail.com";
    ignores = [".DS_Store"];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.gh.enable = true;

  programs.lazygit.enable = true;
}
