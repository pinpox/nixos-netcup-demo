{ config, pkgs, ... }: {

  # Mostly auto-generated
  # nixos-generate-config --show-hardware-config
  imports = [ ./hardware-configuration.nix ];

  /*
  # The lounge irc webclient
  services.thelounge = {
    enable = true;
    port = 9090;
    public = false;
    extraConfig = {
      host = "127.0.0.1";
      reverseProxy = true;
      theme = "morning";
    };
  };

  ### Reverse Proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."demo.megaclan3000.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.thelounge.port}";
        proxyWebsockets = true;
      };
    };
  };

  # Acme for certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = "foo@bar.com";
  };
  */

  # "Install" git
  environment.systemPackages = [ pkgs.git ];

  # Time zone and internationalisation
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking and SSH
  networking = {
    firewall.enable = true;
    firewall.interfaces.eth0.allowedTCPPorts = [ 80 443 ];
    hostName = "awesome-server-01";
    interfaces.eth0.useDHCP = true;
  };

  # User configuration
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSJJs01RqXS6YE5Jf8LUJoJVBxFev3R18FWXJyLeYJE"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm11sPvZgi/QiLaB61Uil4bJzpoz0+AWH2CHH2QGiPm" # Netcup demo key github
  ];

  # Enable ssh
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "23.05";
}
