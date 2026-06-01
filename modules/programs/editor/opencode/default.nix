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
        agents = ./agents; 
        skills = ./skills; # text with ---metadata--- first
        settings = {
          permissions = { # according to docs, works for agent.permissions too but according to nixos config this doesnt exist.
            bash = {
              "*" = "ask";
              "rm *" = "ask";
              "git push *" = "ask";
              "sudo *" = "ask";
              "*.env*" = "ask";
            };
            external_directory = {
              "~/Here on earth2/**" = "allow";
              "~/Here on earth/**" = "deny";
            };
            edit = {
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
          };
        };
      };
    })
  ];
}
