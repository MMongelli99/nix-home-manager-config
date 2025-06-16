{
  imports = [
    ./plugins/scrollbar.nix
    ./plugins/cursorline.nix
    ./plugins/modicator.nix
    ./plugins/bufferline.nix
    ./plugins/statusline.nix
    ./languages/nix.nix
    ./lsp.nix
  ];
  vim = {
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
      transparent = true;
    };
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    formatter.conform-nvim.enable = true;
    telescope.enable = true;
    visuals = {
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
    git = {
      enable = true;
      git-conflict.enable = true;
    };
  };
}
