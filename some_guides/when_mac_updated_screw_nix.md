

Idk why, last time I updated macos my installation of nix was compleatly lost. Maybe a path variable is missing, or something. 
But running the following installer script made it easily find the existing installation and bring things back to normal.

```
 curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 

```
Found it [here](https://github.com/LnL7/nix-darwin/issues/610).
