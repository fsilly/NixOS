{
  lib,
  pkgs,
  ...
}:
let
  skills = { # can also do like interal-* = "permission"
    cringe = {
      skill = builtins.readFile ./skills/cringe.md;
      permission = "ask";
    };
  };
in
{
  home-manager.sharedModules = [
    (_: {
      programs.opencode = {
        enable = true;
        package = pkgs.opencode;
        context = builtins.readFile ./global_context/global_context_v1.md;
        commands = ./commands; # folder of .md files prompt directly
        #themes = ./themes; # lits of themes, to enable them go in tui ?
        skills = ./skills; # text with ---metadata--- first
        settings = {
          mcp = {
            "deepwiki" = {
              url = "https://mcp.deepwiki.com/mcp";
              type = "remote";
              enabled = true;
            };
            "github" = {
               url = "https://api.githubcopilot.com/mcp/";
               "oauth" = false;
               "headers" = {
                 "Authorization" = "Bearer {env =GITHUB_PERSONAL_ACCESS_TOKEN}";
               };
               type = "remote";
               enabled = true;
            };
          };
          agent = {
            investigator = {
              #mode = "subagent";
              reasoningEffort = "high";
              textVerbosity = "high";
              mode = "primary";
              prompt = builtins.readFile ./agents/investigator.md;
              #permission = ''edit = "deny"'';
            };
            investigator-sub = {
              mode = "subagent";
              reasoningEffort = "high";
              textVerbosity = "low";
              prompt = builtins.readFile ./agents/sub-investigator.md;
              #permission = ''edit = "deny"'';
            };
            code-reviewer = {
              mode = "subagent";
              reasoningEffort = "high";
              textVerbosity = "low";
              prompt = builtins.readFile ./agents/code-reviewer.md;
              #permission = ''edit = "deny"'';
            };
#            tester = {
#              mode = "subagent";
#              reasoningEffort = "high";
#              textVerbosity = "high";
#              prompt = builtins.readFile ./agents/tester.md;
#              permission = ''edit = "deny"'';
#            };
#            documentation = {
#              mode = "subagent";
#              reasoningEffort = "low";
#              textVerbosity = "high";
#              prompt = builtins.readFile ./agents/documentation.md;
#              permission = ''edit = "deny"'';
#            };
          };
          permission = { # according to docs, works for agent.permissions too but according to nixos config this doesnt exist.
          "question" =  "allow";
          "webfetch" =  "allow";
          "websearch" =  "allow";
          "doom_loop" = "ask";
            bash = {
              "*" = "allow";
              "rm *" = "ask";
              "git push *" = "ask";
              "sudo *" = "ask";
              "*.env*" = "ask";
              "ssh*rm *" =  "ask";
              "rm* /tmp*" =  "allow";
              "*--hard*" =  "ask";
              "*--force*" =  "ask";
              "chmod *" =  "ask";
              "chown *" =  "ask";
              "chgrp *" =  "ask";
              "kill *" =  "ask";
              "killall *" =  "ask";
              "pkill *" =  "ask";
              "curl *|*sh*" =  "ask";
              "wget *|*sh*" =  "ask";
              "git stash drop *" =  "ask";
              "git stash clear*" =  "ask";
              "git clean *" =  "ask";
              "git restore *" =  "ask";
              "reboot*" =  "ask";
              "shutdown*" =  "deny";
              "poweroff*" =  "deny";
              "dd *" =  "deny";
              "mkfs*" =  "deny";
              "fdisk *" =  "deny";
              "parted *" =  "deny";
              "wipefs *" =  "deny";
              "*--no-preserve-root*" =  "deny";
            };
            external_directory = {
              "~/Here on earth2/**" = "allow";
              "~/Here on earth/**" = "deny";
              "*" =  "ask";
              "/tmp" =  "allow";
              "/tmp/*" =  "allow";
            };
            edit = {
              "*" = "allow";
              "/**" = "deny";
              "~/**" = "ask";
              "/home/**" = "ask";
            };
            read = {
              "*" = "allow";
              "*.env *" = "deny";
              "*.env" = "deny";
              "*.env.example" = "allow";
            };
            "glob" = {
              "*" = "allow";
            };
            "grep" = {
              "*" = "allow";
            };
            "task" = {
              "*" = "allow";
            };
            "skill" = {
              "*" = "allow";
            };
            "lsp" = {
              "*" = "allow";
            };
          };
        };
      };
    })
  ];
}
