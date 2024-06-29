{ config, pkgs, inputs, ... }:

{ 
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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
    eza
    iterm2
    tmux
    zsh-powerlevel10k
    meslo-lgs-nf


    # TODO: to try in the future
    # virtualbox  # not available on MacOS
    # cached-nix-shell  # only avaialble on NixOS and Linux
    # devbox  # wasn't a fan but might try again in the future
    # zed-editor  # broken package, how to allow it?

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

  programs.nixvim = {
    enable       = true; 
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;
     
    # NixVim modules colorschemes: https://github.com/nix-community/nixvim/tree/main/plugins/colorschemes
    #colorschemes.nord.enable = true;
    #plugins.lightline.enable = true;
    
    # vimPlugin colorschemes: https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/applications/editors/vim/plugins/generated.nix
    extraPlugins = [ pkgs.vimPlugins.pure-lua ];
    colorscheme = "moonlight"; 
    plugins.lightline.enable = false; # lightline only inherits colorschemes from Nixvim modules

  };
  
  # basically copy the whole nvchad that is fetched from github to ~/.config/nvim
  # xdg.configFile."nvim/" = {
  #   source = (pkgs.callPackage ./nvchad/default.nix{}).nvchad;
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh
    '';
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    shellAliases = {
      # executing iTerm2 from command line has problems when using Nix's default iTerm2 path
      iTerm2 = "exec ~/Applications/Home Manager Apps/iTerm2.app/Contents/MacOS/iTerm2";
    };
  };

}
