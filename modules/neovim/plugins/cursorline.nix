{
  vim.visuals.nvim-cursorline = {
    enable = true;
    setupOpts.cursorline = {
      enable = true;
      timeout = 0;
      number = false;
      cursorword = {
        enable = true;
        min_length = 3;
        hl.underline = true;
      };
    };
  };
}
