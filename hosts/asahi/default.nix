{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    ../../configuration.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    asahi-bless
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    # HibernateDelaySec = "1h";
    HandleLidSwitchExternalPower = "ignore";
    HandleSuspendKey = "suspend";
  };

  hardware.asahi = {
    enable = true;
    # useExperimentalGPUDriver = true;
    peripheralFirmwareDirectory = /boot/vendorfw;
    setupAsahiSound = true;
  };

  boot = {
    kernelParams = [
      "appledrm.show_notch=1"
    ];
    loader.efi.canTouchEfiVariables = false;
  };
}
