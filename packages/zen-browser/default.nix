{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  undmg,
}:
let
  version = "1.7.6b";
  pname = "zen-browser";
  meta = {
    description = "Experience tranquility while browsing the internet with Zen! Our mission is to give you a perfect balance for speed, privacy and productivity";
    homepage = "https://zen-browser.app/";
    downloadPage = "https://zen-browser.app/download/";
    license = lib.licenses.mpl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # maintainers = with lib.maintainers; [ mmongelli99 ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  };

  linux =
    let
      src = fetchurl {
        url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage";
        sha256 = "GJuxooMV6h3xoYB9hA9CaF4g7JUIJ2ck5/hiQp89Y5o=";
      };
      appimageContents = appimageTools.extractType1 { inherit pname version src; };
    in
    appimageTools.wrapType1 {
      inherit pname version src meta;
    };

  darwin = stdenvNoCC.mkDerivation (finalAttrs: rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.macos-universal.dmg";
      sha256 = "tO9yioBP3HBgskMzQ3fKhcjAK/XpZ5Affr2Kr69GxzE=";
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Zen Browser.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/${sourceRoot}"
      cp -R . "$out/Applications/${sourceRoot}"

      runHook postInstall
    '';

    dontFixup = true;
  });
in
if stdenvNoCC.hostPlatform.isLinux then linux else darwin
