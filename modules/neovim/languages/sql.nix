{
  vim.languages.sql = {
    enable = true;
    dialect = "sqlite";
    extraDiagnostics.enable = true;
    # format.enable = true;
    lsp.enable = false;
    treesitter.enable = false;
  };
}
