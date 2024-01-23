---
theme: ./path/to/theme.json
author: pinpox
date: 2024-01-11
paging: Slide %d / %d
---

# Overview

1. Nix language basics
2. Introduction to flakes
3. NixOS configurations
4. Deploying a service on a server

---

# Nix language basics

## Data types

**Primitives:**

- String
- Number
- Path
- Boolean
- Null

**List:**

```nix
[ "foo" "bar" "baz" ]
```

**Attribute Set:**

```nix
{ a = "b", c = 3; }
```

https://nixos.org/manual/nix/stable/language/values

---
# Nix language basics

## Data types

```nix
{
  author = "pinpox";
  age = 33;

  address = {
    street = "foo";
    number = 5;
  }

  # Attribute set inline
  notebook.operatingSystem = "linux";
  notebook.cpuCores = 4;

  topics = ["nixos", "nix", "foobar"];
}
```

---

## Basic language constructs

### let ... in

```nix
let
  numberOne = 1;
in
{
  threePlusOne = 3 + numberOne;
  fourPlusOne = 4 + numberOne;
}
```

---
## Basic language constructs
### Functions

```nix
{
  circleArea = r: 3.1415 * r * r;
  concatThreeStrings = { x, y, z }: z + y + x;
}
```

Call with:

```
nix-repl> circleArea 5
78.5375
nix-repl> concatThreeStrings {x = "foo"; y = "bar"; z = "baz"; } 
"foobarbaz"
```

### Other

Conditionals, rec, with, inherit...

https://nixos.org/manual/nix/stable/language/constructs

---

## Flakes

Flakes are the `unit for packaging Nix code` in a reproducible and
discoverable way.

A flake is a filesystem tree (e.g. Git repo) that contains a file named
`flake.nix` in the root directory.

### Minimal valid flake

```nix
# flake.nix
{
    description = "A simple flake";
    inputs = { };
    outputs = { self }: { }; # Required
}
```

https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#flake-format

---

## Flakes
### Inputs

```nix
{
  description = "A simple flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    myproject.url = "git+ssh://git@example.com/someone/myproject?ref=v1.2.3";
    myproject.flake = false;
  };
  outputs = { self }: { };
}
```

Other input types: path, tarball, mercurial, gitlab ...

https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#flake-inputs

---

## Flakes
### Outputs

A function that [...] yields the Nix values (attribute set) provided by this flake.

The attributes can have arbitrary values, but there is an expected output
schema.

Examples:

- Packages (`packages`)
- Apps (`apps`)
- Development shells (`devShells`)
- System configurations (`nixosConfigurations`)

https://nixos.wiki/wiki/Flakes#Output_schema

---

## System Configurations

`flake.nix`
```nix
{
  description = "Flake with my systems";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
 
  outputs = { self, nixpkgs }: {
    nixosConfigurations.awesome-server-01 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
```

`configuration.nix`

```nix
{ config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.firefox ];
  # ...
}
```

Run `nix flake show`

https://search.nixos.org/options

---

## System Configurations
### A basic configuration

`configuration.nix`
```nix
{ config, pkgs, ... }: {

  # "Install" git
  environment.systemPackages = [ pkgs.git ];

  # Time zone and internationalisation
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking and SSH
  networking = {
    hostName = "awesome-server-01";
    interfaces.eth0.useDHCP = true;
  };

  # User configuration
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSJJs01RqXS6YE5Jf8LUJoJVBxFev3R18FWXJyLeYJE"
  ];

  # Enable ssh
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "23.05";
}
```
---
## System Configurations
### Adding a service

`configuration.nix`
```nix

# ...

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
```

---
## System Configurations
### Reverse Proxy

`configuration.nix`
```nix
services.nginx = {
  enable = true;
  recommendedProxySettings = true;
  recommendedTlsSettings = true;

  virtualHosts."demo.megaclan3000.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090"; # Hard-coded for simplicity
      proxyWebsockets = true;
    };
  };
};

security.acme = {
  acceptTerms = true;
  defaults.email = "foo@bar.com";
};
```

---
## System Configurations
### Deployment

🚀 Demo time 🚀

```sh
nix flake show
nix flake check
nixos-rebuild switch --target-host root@myserver --flake ".#awesome-server-01"
```

---
## More topics

- Packaging software
- Reproducible development shells and environments
- Secret management
- CI and caching
- Container management
- Generating configured images
- VM-tests
- Deployment tools

[Options and Packages](https://search.nixos.org/)

---
