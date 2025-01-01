{ pkgs, ... }:
{
  environment.pathsToLink = [
    "/Applications"
  ];
  environment.systemPackages = [ ];
  environment.systemPath = [
    #"/opt/homebrew/bin"
  ];
  #homebrew = {
  #  enable = true;
  #  taps = [ ];
  #  brews = [ ];
  #  casks = [ ];
  #};
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };
  services = {
    nix-daemon.enable = true;
    skhd.enable = true;
    yabai = {
      enable = true;
      enableScriptingAddition = true;
    };
  };
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 30;
      KeyRepeat = 1;
    };
    dock.autohide = true;
    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
    };
  };
  system.stateVersion = 4;
  users.users.cl = {
    name = "cl";
    home = "/Users/cl";
  };
}
