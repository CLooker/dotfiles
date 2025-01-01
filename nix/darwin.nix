{ pkgs, ... }:
{
  environment.pathsToLink = [
    "/Applications"
  ];
  environment.systemPackages = with pkgs; [
    getopt
    switchaudio-osx
  ];
  environment.systemPath = [
    "/opt/homebrew/bin"
  ];
  homebrew = {
    enable = true;
    brews = [
#      "bash-language-server"
#      "lua-language-server"
    ];
    casks = [
      "ghostty@tip"
    ];
    taps = [];
  };
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
      KeyRepeat = 1;
      InitialKeyRepeat = 30;
      NSAutomaticSpellingCorrectionEnabled = true;
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
