{
  vim.lsp = {
    enable = true;
    mappings = let
      leader = key: "<leader>${key}";
    in {
      format = leader "f";
      goToDeclaration = leader "gg";
      goToDefinition = leader "gd";
      goToType = leader "gt";
      hover = leader "h";
      openDiagnosticFloat = leader "e";
    };
  };
}
