{ inputs, pkgs, ... }:
{
  # users.groups.alohahenry = {};
  # users.users.alohahenry.group = "alohahenry";
  
  # users.users.alohahenry.extraGroups = [ "wheel" ];
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    # Run `sudo nixos-generate-config --show-hardware-config | tee hardware-configuration.nix`
    # and uncomment this line.
    ./hardware-configuration.nix
  ];

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = ["NOPASSWD"];
        }
      ];
      groups = ["wheel"];
    }];
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
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
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  environment.systemPackages = with pkgs; [
    chromium
    asahi-bless
    git
  ];

  users.mutableUsers = true;

  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  # };

  system.stateVersion = "25.05";
}
