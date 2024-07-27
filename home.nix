{ config, pkgs, inputs, ... }:

{ 
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      # allowBroken = true;
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./nixvim.nix
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

    neofetch
    tree
    eza
    iterm2
    tmux
    zsh-powerlevel10k
    meslo-lgs-nf
    ripgrep # needed for telescope.nvim
    warp-terminal
    neovide
    cached-nix-shell

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
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".ghc/ghci.conf".text = ''
      -- multiline mode
      :set +m
      -- prompt for each line input
      :set prompt  "𝝺 ❯ "
      -- how to add color: https://wiki.haskell.org/GHCi_in_colour
      :set prompt "\ESC[35m\STX𝝺 ❯ \ESC[m\STX"
      -- prompt for each line of multiline input
      :set prompt-cont "... "
      -- add color to multiline continuation
      :set prompt-cont "\ESC[35m\STX... \ESC[m\STX" 
    '';
  };

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
  
  programs.zsh = {
    
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      switch   = "home-manager switch";
      git-tree = "git log --graph --decorate --oneline $(git rev-list -g --all)";
    };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "git" "systemd" "rsync" "kubectl" ];
    #   theme = "terminalparty";
    # }; 
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh
    ''; 

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
