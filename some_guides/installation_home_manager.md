

Here are the steps for Home Manager installation here on a mac system using nix.



```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```




Got this from [here](https://rycee.gitlab.io/home-manager/index.html#sec-install-standalone).

