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
    # utm
    asahi-bless
    picocom
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="316d", GOTO="m1n1"
    GOTO="not_m1n1"

    LABEL="m1n1"
    GROUP="dialout", MODE="0660"
    SUBSYSTEM=="tty", ATTRS{bInterfaceNumber}=="00", KERNEL=="ttyACM*", SYMLINK+="m1n1"
    SUBSYSTEM=="tty", ATTRS{bInterfaceNumber}=="02", KERNEL=="ttyACM*", SYMLINK+="m1n1-sec"
    LABEL="not_m1n1"
  '';

  users.users.alohahenry.extraGroups = [
    "dialout"
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
