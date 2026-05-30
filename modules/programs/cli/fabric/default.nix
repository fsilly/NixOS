{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  fabricPkg =
    if inputs.fabric.packages.${system} ? default then
      inputs.fabric.packages.${system}.default
    else
      inputs.fabric.packages.${system}.fabric;
in
{
  home-manager.sharedModules = [
    {
      home.packages = with pkgs; [
        fabricPkg

        # Useful companions
        yt-dlp
        ffmpeg
        pandoc
        git
        ripgrep
        fd
      ];

      home.sessionVariables = {
        ########################################
        # Providers
        ########################################

        DEFAULT_VENDOR = "openai";
        DEFAULT_MODEL = "gpt-4o";

        ########################################
        # Ollama
        ########################################

        OLLAMA_HOST = "http://127.0.0.1:11434";

        ########################################
        # Fabric defaults
        ########################################

        FABRIC_DEFAULT_MODEL = "gpt-4o";
        FABRIC_DEFAULT_VENDOR = "openai";
      };

      xdg.configFile."fabric/config.yaml".text = ''
        version: 1

        defaults:
          vendor: openai
          model: gpt-4o

        patterns:
          model: gpt-4o

        transcription:
          model: whisper-1

        youtube:
          enabled: true

        cache:
          enabled: true

        logging:
          level: info
      '';

      xdg.configFile."fabric/patterns/.keep".text = "";
      xdg.configFile."fabric/plugins/.keep".text = "";

      programs.zsh.shellAliases = {
        fab = "fabric";
        fp = "fabric --pattern";
        fs = "fabric --stream";
      };

      programs.bash.shellAliases = {
        fab = "fabric";
        fp = "fabric --pattern";
        fs = "fabric --stream";
      };
    }
  ];
}
