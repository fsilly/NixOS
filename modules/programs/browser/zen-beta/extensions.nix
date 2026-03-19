{ inputs, pkgs, lib }:
let
  extensions = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
in {
  extensions = with extensions; [
    ublock-origin
    bitwarden
    firemonkey
    darkreader
    sponsorblock
    return-youtube-dislikes
    #frankerfacez
  ];

  extensionsNur = with pkgs.nur.repos.rycee.firefox-addons; [
    floccus
    kagi-search
    multi-account-containers
    bitwarden
    firemonkey
    sponsorblock
    return-youtube-dislikes
    ublock-origin
    istilldontcareaboutcookies
  ];

  enabledExtensions = with extensions; [
    ublock-origin
    firemonkey
    darkreader
    # Keep literal IDs for special cases
  ] ++ [
    "queryamoid@kaply.com"
    "{c4b582ec-4343-438c-bda2-2f691c16c262}"
  ];

  toolbarExtensions = with extensions; [
    firemonkey
    ublock-origin
  ] ++ [
    "{c4b582ec-4343-438c-bda2-2f691c16c262}"
  ];

  extensionSettings = with extensions; {
    "*" = {
      #blocked_install_message = "Addon is not added in the nix config";
      #installation_mode = "blocked";
    };
  "3rdparty".Extensions = {
    ${extensions.darkreader.addonId} = {
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
    };

    ${extensions.ublock-origin.addonId} = {
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
            "https://raw.githubusercontent.com/yokoffing/filterlists/main/privacy_essentials.txt"
            "https://raw.githubusercontent.com/yokoffing/filterlists/main/annoyance_list.txt"
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
        ];
      };
    };
  };
};}
