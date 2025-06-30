{
  # imports = [
  #   ./plugins/trouble.nix
  #   ./languages/markdown.nix
  # ];
  vim.lsp = let
    leader = key: "<leader>${key}";
  in {
    enable = true;
    trouble.enable = true;
    trouble.mappings.workspaceDiagnostics = leader "wd";
    mappings = {
      format = leader "f";
      goToDeclaration = leader "gg";
      goToDefinition = leader "gd";
      goToType = leader "gt";
      hover = leader "h";
      openDiagnosticFloat = leader "e";
    };
  };
}
