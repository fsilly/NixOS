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

# TODO
# DEFAULT_VENDOR=OpenRouter
# DEFAULT_MODEL=openrouter/owl-alpha
# DEFAULT_MODEL_CONTEXT_LENGTH=1.05M
# PATTERNS_LOADER_GIT_REPO_URL=https://github.com/danielmiessler/fabric.git
# PATTERNS_LOADER_GIT_REPO_PATTERNS_FOLDER=data/patterns
# PROMPT_STRATEGIES_GIT_REPO_URL=https://github.com/danielmiessler/fabric.git
# PROMPT_STRATEGIES_GIT_REPO_STRATEGIES_FOLDER=data/strategies
# OPENROUTER_API_KEY=
# OPENROUTER_API_BASE_URL=https://openrouter.ai/api/v1

#      xdg.configFile."fabric/config.yaml".text = ''
#        version: 1
#
#        defaults:
#          vendor: openai
#          model: gpt-4o
#
#        patterns:
#          model: gpt-4o
#
#        transcription:
#          model: whisper-1
#
#        youtube:
#          enabled: true
#
#        cache:
#          enabled: true
#
#        logging:
#          level: info
#      '';

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
