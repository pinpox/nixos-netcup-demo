# nixos-netcup-demo

Material for a short presentation and demo on how to use NixOS to deploy a
simple service + reverse proxy using flakes. Intended as an opinionated
tutorial. Slides use the [slides](https://github.com/maaslalani/slides)
presentation tool.

## Demo server setup

The following was tested on [netcup](https://netcup.de) using a `VPS 500 G10s`
server. Other providers or server variants will probably work too, but are
untested at this point.

After booking the `VPS 500 G10s` you will get an e-mail with the root
credentials and a `debian-minimal` image preinstalled. 

Setup public-key based authentication on the server and run nixos-infect. The
public key will persist after infection.

```
ssh-copy-id -o PubkeyAuthentication=no -o PreferredAuthentications=password  root@94.16.117.189
ssh root@94.16.117.189
apt install curl
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-22.11 bash -x
```

The server will reboot. After it comes back online, log in and copy the contents
of `/etc/nixos/hardware-configuration.nix` into ours if it differs. We **do
NOT** need the generated `configuration.nix`

```
ssh root@94.16.117.189 cat /etc/nixos/hardware-configuration.nix
```

You now have a NixOS server and can deploy this demo. You might want to set DNS
records if you have a domain and configure the nginx virtual host accordingly,
otherwise deployment will still work, but you won't get SSL certificates
generated as the DNS challenge will fail.

```
nixos-rebuild switch --flake '.#awesome-server-01' --target-host root@94.16.117.189 
```

Note: While `nixos-infect` works fine and is appropriate for a demo, you might
want to look into other initial deployment methods for production servers if,
e.g. if you need other partition layouts. Popular options are
[nixos-anywhere](https://github.com/nix-community/nixos-anywhere) or generating
and uploading a pre-backed `.qcow2` image, which can be generated from a flake.

