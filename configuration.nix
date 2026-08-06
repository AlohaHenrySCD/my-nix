{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  users.users.alohahenry = {
    isNormalUser = true;
    home = "/home/alohahenry";
    extraGroups = [
      "video"
      "input"
      "wheel"
      "networkmanager"
    ];
    # shell = pkgs.fish;
  };
  nixpkgs.config.allowUnfree = true;

  # brightness controll
  hardware.brillo.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    # Run `sudo nixos-generate-config --show-hardware-config | tee hardware-configuration.nix`
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
            esc = "capslock";
          };
        };
      };
    };
  };

  fonts.packages = [
    pkgs.jetbrains-mono
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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
    extraOpts = {
      # "ExtensionSettings" = {
      #   "bpoadfkcbjbfhfodiogcnhhhpibjhbnh" = {

      #   }
      # };
      "RestoreOnStartup" = 1;
      "BackgroundModeEnabled" = false;
    };
  };

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

  programs.fish.enable = true;
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
    kernelParams = [
      "appledrm.show_notch=1"
    ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    loader.systemd-boot.configurationLimit = 8;
  };

  hardware.graphics.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = /boot/vendorfw;
    setupAsahiSound = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  time = {
    timeZone = "Asia/Shanghai";
  };

  networking = {
    # hostName = "alohahenry";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  programs.starship.enable = true;

  # services.mihomo = {
  #   enable = true;
  #   configFile = "/home/alohahenry/.config/mihomo.yaml";
  # };

  environment.systemPackages = with pkgs; [
    papers
    alacritty
    fuzzel
    home-manager
    chromium
    asahi-bless
    git
    tlrc
    navi
    pavucontrol
    fzf
    i3bar-river

    # programing
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    clang
    clang-tools
    bash-language-server
    vscode-css-languageserver
    yaml-language-server
    fish-lsp
    haskell-language-server
    superhtml
    typescript-language-server
    vscode-json-languageserver
    texlab
    marksman
    nil
    ty
    taplo
  ];

  environment.sessionVariables = lib.mkForce {
    LC_MESSAGES = "zh-CN.UTF-8";
    LANG = "zh_CN.UTF-8";
    XMODIFIERS = "@im=fcitx";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
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
