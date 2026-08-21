{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pythonFinal: pythonPrev: {
          nanoemoji = pythonPrev.nanoemoji.overrideAttrs (oldAttrs: {
            version = "0.16.0";
            src = prev.fetchFromGitHub {
              owner = "googlefonts";
              repo = "nanoemoji";
              rev = "v0.16.0";
              hash = "sha256-FysyKC01XBnRiur5RR9fcsTxQqE8x0JJHSoe3q6JtKc=";
            };
            doCheck = false;
          });
        })
      ];
    })
  ];
  users.users.alohahenry = {
    isNormalUser = true;
    home = "/home/alohahenry";
    extraGroups = [
      "video"
      "input"
      "wheel"
      "networkmanager"
      "openrazer"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.overlays = [ inputs.helix-plugins.overlays.default ];
  # hjem.extraModules = [ inputs.helix-plugins.hjemModules.default ];

  # hjem.users.alohahenry = {
  #   enable = true;
  #   user = "alohahenry";
  #   directory = "/home/alohahenry";

  # };
  # hjem.users.alohahenry.programs.helix = {
  #   package = pkgs.steelix;
  #   enable = true;
  #   plugins = with pkgs.helixPlugins; [
  #     notify
  #     oil
  #     breadcrumbs
  #     fake-warp
  #     smooth-scroll
  #     forest
  #     glyph
  #     show-keys
  #     moka
  #   ];
  # };

  # nixpkgs.overlays = [ inputs.helix-plugins.overlays.default ];

  # programs.helix = {
  #   enable = true;
  #   plugins = with pkgs.helixPlugins; [
  #     notify
  #     oil
  #     breadcrumbs
  #     fake-warp
  #     smooth-scroll
  #     forest
  #     glyph
  #     show-keys
  #     moka
  #   ];
  # };

  # brightness controll
  hardware.brillo.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    # inputs.helix-plugins.nixosModules.default # Run `sudo nixos-generate-config --show-hardware-config | tee hardware-configuration.nix`
    # and uncomment this line.
    ./hardware-configuration.nix
  ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      device.routes = true;
    };
  };
  services.blueman.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    # HibernateDelaySec = "1h";
    HandleLidSwitchExternalPower = "ignore";
    # testing
    HandleSuspendKey = "suspend";
  };

  services.dbus.enable = true;

  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 4*1024;
  #   }
  # ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Symbols Nerd Font Mono"
      ];

      sansSerif = [
        "Noto Sans"
        "Symbols Nerd Font"
      ];

      serif = [
        "Noto Serif"
        "Symbols Nerd Font"
      ];
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            capslock = "esc";
            esc = "f12";
          };
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
  # ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "alohahenry";
        command = "${config.programs.niri.package}/bin/niri-session";
      };
    };
  };
  systemd.user.services.niri.enableDefaultPath = false;

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;

  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.deault = "*";
  };

  programs.fish.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey
      "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" # immersive translate
      "hfjbmagddngcpeloejdejnfgbamkjaeg" # vimium c
      "bkdgflcldnnnapblkhphbgpggdiikppg" # duck duck go
    ];
    # override.commandLineArgs = [
    #   "--extensions-on-chrome-urls --extensions-on-extension-urls"
    # ];
    extraOpts = {
      "RestoreOnStartup" = 1;
      "BackgroundModeEnabled" = false;
    };
  };

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };

  users.extraUsers.alohahenry = {
    shell = pkgs.fish;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  boot = {
    kernel.sysctl = {
      "net.ipv6.conf.all.accept_ra" = 2;
      "net.ipv6.conf.default.accept_ra" = 2;
      "net.ipv6.conf.wlan0.accept_ra" = 2;
    };
    kernelParams = [
      "appledrm.show_notch=1"
    ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    loader.systemd-boot.configurationLimit = 8;
  };

  hardware.graphics.enable = true;
  # hardware.opengl.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.asahi = {
    enable = true;
    # useExperimentalGPUDriver = true;
    peripheralFirmwareDirectory = /boot/vendorfw;
    setupAsahiSound = true;
  };

  hardware.openrazer.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.settings = {
    max-jobs = 8;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  time = {
    timeZone = "Asia/Shanghai";
  };

  # services.clatd.enable = true;
  networking = {
    # hostName = "alohahenry";
    extraHosts = ''
      0.0.0.0 audio-cf-del-874.spotifycdn.com
      0.0.0.0 audio-fa-del-874.spotifycdn.com
    '';
    networkmanager.enable = true;
    networkmanager.wifi.backend = "wpa_supplicant";
    networkmanager.unmanaged = [
      "Mihomo"
      "Meta"
    ];
    # networkmanager.settings = {
    #   main.ndisc = "external";
    # };
    # networkmanager.ensureProfiles.profiles = {
    #   "wlan0" = {
    #     connection = {
    #       id = "wlan0";
    #       type = "wifi";
    #     };
    #     ipv4 = {
    #       method = "auto";
    #     };
    #     ipv6 = {
    #       method = "auto";
    #       # addr-gen-mode = "stable-privacy";
    #       ndisc = "kernel";
    #     };
    #   };
    # };
    # networkmanager.dhcp = true;
    enableIPv6 = true;
    # useDHCP = true;
    # dhcpcd.persistent = true;
    # wireless.iwd = {
    #   enable = true;
    #   settings.General.EnableNetworkConfiguration = true;
    # };
  };

  programs.starship.enable = true;

  # services.mihomo = {
  #   enable = true;
  #   configFile = "/home/alohahenry/.config/mihomo.yaml";
  # };

  environment.systemPackages = with pkgs; [
    # base
    # mesa
    home-manager
    gtk4
    gtk4.dev
    glib
    gsettings-desktop-schemas
    adwaita-icon-theme
    hicolor-icon-theme
    asahi-bless
    git
    tlrc
    navi
    pavucontrol
    fzf
    helix
    # steelix
    # steel
    alacritty
    fuzzel
    kitty
    hugo
    mako
    libnotify

    # gui
    chromium
    kdePackages.kate
    papers
    clash-verge-rev

    # custom
    i3bar-river
    starship
    btop
    lazygit

    # gaming
    # osu-lazer
    # hmcl
    # sbclPackages.frpc
    # frpc
    jdk8
    jdk25
    # glfw
    prismlauncher
    openrazer-daemon
    polychromatic

  ];

  environment.sessionVariables = lib.mkForce {
    LC_MESSAGES = "zh_CN.UTF-8";
    LC_ALL = "zh_CN.UTF-8";
    LC_COLLATE = "zh_CN.UTF-8";
    LANG = "zh_CN.UTF-8";
    XMODIFIERS = "@im=fcitx";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    WAYLAND_DISPLAY = "wayland-1";
    # GDK_BACKEND = "wayland";
    DISPLAY = "wayland-1";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  users.mutableUsers = true;

  system.stateVersion = "25.05";
}
