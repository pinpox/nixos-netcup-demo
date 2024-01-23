{ modulesPath, ... }:
let
  primaryDisk = "/dev/sda";
in
{

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = primaryDisk;
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = "boot";
          start = "0";
          end = "1M";
          flags = [ "bios_grub" ];
        }
        {
          name = "ESP";
          start = "1M";
          end = "512M";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        }
        {
          name = "nixos";
          start = "512M";
          end = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        }
      ];
    };
  };

  fileSystems."/".autoResize = true;
  boot.growPartition = true;

  boot.kernelParams = [ "console=ttyS0" ];

  boot.loader.grub = {
    devices = [ primaryDisk ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.qemuGuest.enable = true;

}
