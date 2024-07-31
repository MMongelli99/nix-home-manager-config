{ pkgs, inputs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      allowBroken = true; # allow hell
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./modules/nixvim.nix
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
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    ## cli tools ##
    neofetch
    trash-cli
    eza # used in custom zsh function `lt`
    bat
    tmux
    zsh-powerlevel10k
    nixfmt-rfc-style
    cached-nix-shell
    ripgrep # needed for telescope.nvim
    ollama

    ## applications ##

    iterm2
    warp-terminal
    neovide
    utm

    ## languages ##

    ghc
    haskellPackages.cabal-install
    haskellPackages.stack
    # haskellPackages.hell

    rustc
    rustup
    # cargo # included in rustup

    python312Packages.python
    python312Packages.pip

    nodejs_22

    ## fonts ##

    meslo-lgs-nf

    # TODO: to try in the future
    # virtualbox            # not available on MacOS
    # devbox                # wasn't a fan but might try again in the future
    # zed-editor            # broken package, how to allow it?
    # haskellPackages.hell  # broken package, debug it?

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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file =
    let
      # Ensure each config file is present at its source path specified below.
      # Home Manager will create/update the file in your home directory upon `home-manager switch`.
      dotfiles = [
        ".p10k.zsh"
        ".ghc/ghci.conf"
        ".tmux.conf"
      ];
    in
    builtins.listToAttrs (
      map (dotfile: {
        name = dotfile;
        value = {
          source = ./dotfiles/${dotfile};
        };
      }) dotfiles
    );

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

  # home.sessionVariables = {
  #   EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish.enable = true;

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
        "copypath" # copy current working directory to clipboard
        "copyfile" # copy contents of file to clipboard
        "copybuffer" # copy command line buffer to clipboard
        "dirhistory" # navigate directories with ALT + arrow keys
        "magic-enter" # execute `git status` when hitting ENTER in a git repo
      ];
      # theme = "wezm";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
      # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh  # your p10k config

      # ohmyzsh magic-enter config
      MAGIC_ENTER_GIT_COMMAND='git status'
      MAGIC_ENTER_OTHER_COMMAND='eza -a'

      ## custom utility functions ##

      list-tree () {
        if [[ "''${1-1}" =~ "[0-9]+" ]]; then   # if first arg is a number
          eza --tree --level ''${1-1} ''${@:2}  # then treat it as level and include rest of args
        else                                    # if arg is anything else
          eza --tree --level 1 $@               # then run args with default level
        fi
      }

    '';

    shellAliases = {
      switch = "home-manager switch";
      git-tree = "git log --graph --decorate --oneline $(git rev-list -g --all)";
      lt = "list-tree";
      # defined in initExtra
      ai = "ollama serve & ollama run llama3.1";
    };

  };

  programs.git = {
    enable = true;
    userName = "Michael Mongelli";
    userEmail = "mmongelli99@gmail.com";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

}
