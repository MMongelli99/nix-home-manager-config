{
  imports = [
    ./plugins
    ./languages
    ./lsp.nix
    ./keymaps.nix
  ];
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
      # transparent = true;
    };
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    formatter.conform-nvim.enable = true;
    telescope.enable = true;
    # fzf-lua.enable = true;
    treesitter.enable = true;
    # languages.enableLSP = true;
    # languages.enableTreesitter = true;
    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };
    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
      highlight-undo = {
        enable = true;
        setupOpts.duration = 1000; # 1 second
      };
    };
    undoFile.enable = true;
    git = {
      enable = true;
      git-conflict.enable = true;
    };
  };
}
