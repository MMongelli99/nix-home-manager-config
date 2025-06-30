{
  vim.keymaps = [
    # Copy to clipboard
    {
      mode = "v";
      key = "<leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = "\"+yg_";
    }
    {
      mode = "n";
      key = "<leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "<leader>yy";
      action = "\"+yy";
    }
    # Paste from clipboard
    {
      mode = "n";
      key = "<leader>p";
      action = "\"+p";
    }
    {
      mode = "n";
      key = "<leader>P";
      action = "\"+P";
    }
    {
      mode = "v";
      key = "<leader>p";
      action = "\"+p";
    }
    {
      mode = "v";
      key = "<leader>P";
      action = "\"+P";
    }
  ];
}
