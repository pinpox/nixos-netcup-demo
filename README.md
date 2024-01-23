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

### Initial deployment (Server is still other OS)

Setup public-key based authentication on the server and run nixos-anywhere for
intial deployment. The public key will persist after infection.

```
ssh-copy-id -o PubkeyAuthentication=no -o PreferredAuthentications=password  root@94.16.117.189
ssh root@94.16.117.189
nix run github:numtide/nixos-anywhere -- --flake .\#awesome-server-01 root@92.60.37.228
```

### Further deployments (Server is NixOS)

You now have a NixOS server and can deploy this demo. You might want to set DNS
records if you have a domain and configure the nginx virtual host accordingly,
otherwise deployment will still work, but you won't get SSL certificates
generated as the DNS challenge will fail.

Further deployments can be done with:

```
nixos-rebuild switch --flake '.#awesome-server-01' --target-host root@94.16.117.189 
```

Note: Other deployment methods are possible and might be more suitable for
multiple servers.
[nixos-anywhere](https://github.com/nix-community/nixos-anywhere) is used here
for simplicity. Other options are using a deployment tool like
[lollypops](https://github.com/pinpox/lollypops) or uploading a pre-backed
`.qcow2` image, which can be generated from a flake.

