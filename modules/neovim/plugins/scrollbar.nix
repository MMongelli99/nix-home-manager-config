{
  vim.visuals.nvim-scrollbar = {
    enable = true;
    setupOpts = {
      throttle_ms = 0;
      handle = {
        blend = 75; # transparency %
        color = "#ffffff";
      };
      marks = {
        Cursor = {
          text = "◼";
          color = "#aaaaaa";
        };
      };
    };
  };
}
