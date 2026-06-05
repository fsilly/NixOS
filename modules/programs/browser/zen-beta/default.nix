{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  defaultProfile = { transparent ? false }: {
    settings = import ./settings.nix { inherit lib; transparent-zen = transparent; };
    bookmarks = import ../bookmarks.nix;
    search = import ./search.nix { inherit pkgs; };
    userChrome = builtins.readFile ./userChrome.css;
    #userContent = builtins.readFile ./userContent.css;
    sine = {
      enable = true;
      mods = [
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # better CtrlTab UI
        "7190e4e9-bead-4b40-8f57-95d852ddc941" #tab title
        "906c6915-5677-48ff-9bfc-096a02a72379" #floating status
        "6c122084-c4ec-4c9e-8cc5-3d87c3a089cb" #margin better
        "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" #better something
        "cb5efa80-f1e1-43ce-8c0b-fece8462d225" #highl something
        "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" #pins hihglight
      ] ++ lib.optionals transparent [
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" #floating history
        "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec" #cleaned url bar
        "642854b5-88b4-4c40-b256-e035532109df" #transparent zen
        #"https://github.com/YashjitPal/Arc-2.0" #arc 2.0
      ];
    };
     #browser.tabs.groups.enabled
    extraConfig = ''
      ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
      ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
      ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
      ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
      lockPref("extensions.formautofill.addresses.enabled", false);
      lockPref("extensions.formautofill.creditCards.enabled", false);
      lockPref("dom.security.https_only_mode_pbm", true);
      lockPref("dom.security.https_only_mode_error_page_user_suggestions", true);
      lockPref("browser.firefox-view.feature-tour", "{\"screen\":\"\",\"complete\":true}");
      lockPref("identity.fxaccounts.enabled", false);
      lockPref("browser.tabs.firefox-view-next", false);
      lockPref("privacy.sanitize.sanitizeOnShutdown", false);
      lockPref("privacy.clearOnShutdown.cache", true);
      lockPref("privacy.clearOnShutdown.cookies", false);
      lockPref("privacy.clearOnShutdown.offlineApps", false);
      lockPref("browser.sessionstore.privacy_level", 0);
      lockPref("floorp.browser.sidebar.enable", false);
      lockPref("geo.enabled", false);
      lockPref("media.navigator.enabled", false);
      lockPref("dom.event.clipboardevents.enabled", false);
      lockPref("dom.event.contextmenu.enabled", false);
      lockPref("dom.battery.enabled", false);
      lockPref("extensions.enabledScopes", 15);
      lockPref("extensions.autoDisableScopes", 0);
      lockPref("browser.newtabpage.activity-stream.floorp.newtab.imagecredit.hide", true);
      lockPref("browser.newtabpage.activity-stream.floorp.newtab.releasenote.hide", true);
      lockPref("browser.search.separatePrivateDefault", true);
    '';
  };
in
{
  # environment.systemPackages = with pkgs; [inputs.zen-browser.packages.${stdenv.hostPlatform.system}.default];
  home-manager.sharedModules = [
    (_: {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        #suppressXdgMigrationWarning = true; Disabled in update
        policies = import ./policies.nix { inherit inputs lib pkgs; };
        languagePacks = [
          "en-GB"
          "en-US"
        ];
        profiles = {
          default = {
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
          } // (defaultProfile { transparent = true; });
          googleised = {
            id = 1; # 0 is the default profile; see also option "isDefault"
            name = "googleised"; # name as listed in about:profiles
            isDefault = false; # can be omitted; true if profile ID is 0
          } // (defaultProfile { transparent = false; });
        };
      };
    })
  ];
}
