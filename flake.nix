{
  description = "Mike's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, config, ... }: {
      
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.mkalias
          pkgs.neovim
          pkgs.alacritty
          pkgs.obsidian
          pkgs.vscode
        ];

      # Homebrew Apps
      
      homebrew = {
        enable = true;
        brews = [
          "mas"
          "nvm"
          "yarn"
          "cocoapods"
          "watchman"
          "pyenv"
          "fastlane"
          "zsh"
          "yt-dlp"
        ];
        casks = [
          "arc"
          "flutter"
          "notion"
          "notion-calendar"
          "clop"
          "numi"
          "displaylink"
          "sourcetree"
          "figma"
          "postman"
          "visual-studio-code"
          "android-studio"
        ];
        masApps = { 
          "WhatsApp" = 1147396723;
          "Slack" = 803453959;
          "Spark" = 6445813049;
          "TextSnipper" = 1528890965;
          "Affinity Designer" = 824183456;
          "Safari Adblock" = 1402042596;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # Custom fonts
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
      ];

      # Mac system preferences

      system.defaults = {
        dock = {
          # auto show and hide dock
          autohide = true;
          # remove delay for showing dock
          autohide-delay = 0.0;
          # how fast is the dock showing animation
          autohide-time-modifier = 0.2;
          expose-animation-duration = 0.2;
          tilesize = 48;
          launchanim = false;
          static-only = false;
          showhidden = true;
          show-recents = false;
          show-process-indicators = true;
          orientation = "bottom";
          mru-spaces = false;
        };
        dock.persistent-apps = [
          "/Applications/Arc.app"
          "/System/Applications/Messages.app"
          "/Applications/WhatsApp.app"
          "/Applications/Slack.app"
          "/Applications/Spark Desktop.app"
          "/Applications/ChatGPT.app"
          "/Applications/Figma.app"
          "/Applications/Notion.app"
          "/Applications/Notion Calendar.app"
          "/Applications/Sourcetree.app"
          "/Applications/Cursor.app"
          "/System/Applications/Utilities/Terminal.app"
        ];
        NSGlobalDomain.AppleInterfaceStyle = "Dark";

      CustomUserPreferences = {
          NSGlobalDomain = {
            # Add a context menu item for showing the Web Inspector in web views
            WebKitDeveloperExtras = true;
          };
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.screensaver" = {
            # Require password immediately after sleep or screen saver begins
            askForPassword = 1;
            askForPasswordDelay = 0;
          };
          "com.apple.screencapture" = {
            location = "~/Desktop";
            type = "png";
          };
          # "com.apple.Safari" = {
          #   # Privacy: don’t send search queries to Apple
          #   UniversalSearchEnabled = false;
          #   SuppressSearchSuggestions = true;
          #   # Press Tab to highlight each item on a web page
          #   WebKitTabToLinksPreferenceKey = true;
          #   ShowFullURLInSmartSearchField = true;
          #   # Prevent Safari from opening ‘safe’ files automatically after downloading
          #   AutoOpenSafeDownloads = false;
          #   ShowFavoritesBar = false;
          #   IncludeInternalDebugMenu = true;
          #   IncludeDevelopMenu = true;
          #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
          #   WebContinuousSpellCheckingEnabled = true;
          #   WebAutomaticSpellingCorrectionEnabled = false;
          #   AutoFillFromAddressBook = false;
          #   AutoFillCreditCardData = false;
          #   AutoFillMiscellaneousForms = false;
          #   WarnAboutFraudulentWebsites = true;
          #   WebKitJavaEnabled = false;
          #   WebKitJavaScriptCanOpenWindowsAutomatically = false;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
          #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
          # };
          # "com.apple.mail" = {
          #   # Disable inline attachments (just show the icons)
          #   DisableInlineAttachmentViewing = true;
          # };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.print.PrintingPrefs" = {
            # Automatically quit printer app once the print jobs complete
            "Quit When Finished" = true;
          };
          "com.apple.SoftwareUpdate" = {
            AutomaticCheckEnabled = true;
            # Check for software updates daily, not just once per week
            ScheduleFrequency = 1;
            # Download newly available updates in background
            AutomaticDownload = 1;
            # Install System data files & security updates
            CriticalUpdateInstall = 1;
          };
          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
          # Prevent Photos from opening automatically when devices are plugged in
          "com.apple.ImageCapture".disableHotPlug = true;
          # Turn on app auto-update
          "com.apple.commerce".AutoUpdate = true;
        };
      };


      # Fixing mac symlink applications
      system.activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
      pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
          '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;
 
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
    
    
    
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macbookpro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            # User owning the Homebrew prefix
            user = "mike";

            # Automatically migrate existing Homebrew installations
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macbookpro".pkgs;
  };

  
}