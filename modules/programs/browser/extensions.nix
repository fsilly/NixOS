{ lib, transparent-zen, ... }:
let
  chars = ["@" "-" "." "{" "}"];

  unwantedChars = [ "@" "." "{" "}" ];

  extensionNames = lib.attrNames (lib.filterAttrs (_: ext: ext.navbar) extensionSettings.common // extensionSettings.zenBrowser);

  sanatizeName = name: ((lib.replaceStrings unwantedChars (lib.replicate (builtins.length unwantedChars) "_")) name) + "-browser-action";

  navbarList = map sanatizeName extensionNames;

  extensionSettings = { # TODO: add firefox one tab ext
    common = {
      "*" = {
        navbar = false;
        blocked_install_message = "Addon is not added in the nix config";
        installation_mode = "blocked";
      };
      "uBlock0@raymondhill.net" = {
        navbar = true;
        private_browsing = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      "firemonkey@eros.man" = {
        navbar = true;
        private_browsing = true;
        default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/firemonkey/latest.xpi";
      };
      "addon@darkreader.org" = {
        navbar = true;
        private_browsing = true;
        # default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      };
      "sponsorBlocker@ajay.app" = {
        navbar = true;
        private_browsing = true;
        default_area = "menupanel";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
      };
      "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
        navbar = true;
        private_browsing = true;
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
      };
#      "{ce25b613-ecd1-47e0-9492-c0260efb633c}" = { # prevent google singin popup everywhere
#        navbar = true;
#        private_browsing = true;
#        installation_mode = "force_installed";
#        install_url = "https://addons.mozilla.org/firefox/downloads/latest/google-sign-in-popup-blocker/latest.xpi";
#      };
      "{71e8313c-dd11-4a7b-b198-ed905778077f}" = { # prevent google singin popup everywhere, same thing idk
        navbar = true;
        private_browsing = true;
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/block-google-sign-in-prompt/latest.xpi";
      };
    };

    zenBrowser = {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4749958/bitwarden_password_manager-2026.3.0.xpi";
      };
      "opensubtitles@stefan.breitenstein" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/en-US/firefox/addon/opensubtitles/latest.xpi";
      };
      "{c4b582ec-4343-438c-bda2-2f691c16c262}" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/600-sound-volume/latest.xpi";
      };
      # View Xpi Id's in Firefox Extension Store
      "queryamoid@kaply.com" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
      };
      "tridactyl.vim@cmcaine.co.uk" = { # Trydactil
        private_browsing = true;
        navbar = true;
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4704384/tridactyl_vim-1.24.5.xpi";
      };
    } // lib.optionalAttrs transparent-zen {
      "{91aa3897-2634-4a8a-9092-279db23a7689}" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/zen-internet/latest.xpi";
      };
      "{74186d10-f6f2-4f73-b33a-83bb72e50654}" = {
        private_browsing = true;
        navbar = true;
        #default_area = "navbar";
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/transparent-zen/latest.xpi";
      };
    };

    firefox = {

    };
    floorp = {

    };
  };
in
{
  navbar = [
    #"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
    # "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
    #"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
    #"firemonkey_eros_man-browser-action"
    #"ublock0_raymondhill_net-browser-action"
    #"addon_darkreader_org-browser-action"
    #"queryamoid_kaply_com-browser-action"
    #"opensubtitles@stefan.breitenstein"
    #"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action" #open subtitles
    #"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" #bitwarden
    # "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
  ] ++ navbarList;

  unified-extensions-area = [
#    #"_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action"
#    "firemonkey_eros_man-browser-action"
#    "ublock0_raymondhill_net-browser-action"
#    "addon_darkreader_org-browser-action"
#    "queryamoid_kaply_com-browser-action"
#    "opensubtitles@stefan.breitenstein"
#    "_c4b582ec-4343-438c-bda2-2f691c16c262_-browser-action" #open subtitles
#    "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" #bitwarden
#    # "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
  ] ++ navbarList;

  inherit extensionSettings;

  extensionConfig = {
    "uBlock0@raymondhill.net" = {
      advancedSettings = [
        [
          "userResourcesLocation"
          "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/video-swap-new/video-swap-new-ublock-origin.js"
        ]
      ];
      adminSettings = {
        userFilters = lib.concatMapStrings (x: x + "\n") [
          "twitch.tv##+js(twitch-videoad)"
          "||1337x.vpnonly.site"
          "||snowvan.xyz^"
        ];
        userSettings = rec {
          uiTheme = "dark";
          uiAccentCustom = true;
          uiAccentCustom0 = "#CA9EE6";
          cloudStorageEnabled = lib.mkForce false;
          advancedUserEnabled = true;
          userFiltersTrusted = true;
          importedLists = [
            "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
            "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
            "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
            # "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
            "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
            "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
            "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
          ];
          externalLists = lib.concatStringsSep "\n" importedLists;
          popupPanelSections = 31;
        };
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "adguard-generic"
          "adguard-mobile"
          "easyprivacy"
          "adguard-spyware"
          "adguard-spyware-url"
          "block-lan"
          "urlhaus-1"
          "curben-phishing"
          "plowe-0"
          "dpollock-0"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"
          "fanboy-social"
          "adguard-social"
          "fanboy-thirdparty_social"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "adguard-mobile-app-banners"
          "adguard-other-annoyances"
          "adguard-popup-overlays"
          "adguard-widgets"
          "ublock-annoyances"
          "DEU-0"
          "FRA-0"
          "NLD-0"
          "RUS-0"
          "https://raw.githubusercontent.com/reek/anti-adblock-killer/master/anti-adblock-killer-filters.txt"
          "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Dandelion Sprout's Anti-Malware List.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/BrowseWebsitesWithoutLoggingIn.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
          "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
          "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
          "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean-filters/blob/raw?file=bpc-paywall-filter.txt"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/ClearURLs for uBo/clear_urls_uboified.txt"
          "https://raw.githubusercontent.com/iam-py-test/my_filters_001/main/antimalware.txt"
          # "https://raw.githubusercontent.com/OsborneLabs/Columbia/master/Columbia.txt"
          "https://raw.githubusercontent.com/bogachenko/fuckfuckadblock/master/fuckfuckadblock.txt?_=rawlist"
          "user-filters"
        ];
      };
    };
    "addon@darkreader.org" = {
      enabled = true;
      automation = {
        enabled = true;
        behavior = "OnOff";
        mode = "system";
      };
      detectDarkTheme = true;
      enabledByDefault = true;
      changeBrowserTheme = false;
      enableForProtectedPages = true;
      fetchNews = true;
      syncSitesFixes = true;
      previewNewDesign = true;
      # previewNewestDesign = true; # TODO: test

      # Catppuccin mocha theme
      /*
        theme = {
          mode = 1;
          brightness = 100;
          contrast = 100;
          grayscale = 0;
          sepia = 0;
          useFont = false;
          fontFamily = "Open Sans";
          textStroke = 0;
          engine = "dynamicTheme";
          stylesheet = "";
          darkSchemeBackgroundColor = "#1e1e2e";
          darkSchemeTextColor = "#cdd6f4";
          lightSchemeBackgroundColor = "#eff1f5";
          lightSchemeTextColor = "#4c4f69";
          scrollbarColor = "";
          selectionColor = "#585b70"; # For the light scheme: #acb0be
          styleSystemControls = true;
          lightColorScheme = "Default";
          darkColorScheme = "Default";
          immediateModify = false;
        };
      */

      # enabledFor = [];
      # disabledFor = [];
    };
  };
}
