{ config, pkgs, ... }:
{
  environment.pathsToLink = [
    "/Applications"
  ];
  environment.systemPackages = with pkgs; [
    discrete-scroll
    getopt
    switchaudio-osx
  ];
  environment.systemPath = [
    "/opt/homebrew/bin"
  ];
  homebrew = {
    enable = true;
    brews = [
      # "bash"
      #      "bash-language-server"
      #      "lua-language-server"
      "neovim"
    ];
    casks = [
      "ghostty@tip"
    ];
    taps = [];
  };
  ids.gids.nixbld = 350;
  launchd = {
    user = {
      agents = {
        discretescroll = {
          command = "${pkgs.discrete-scroll}/bin/DiscreteScroll";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/discretescroll.out.log";
            StandardErrorPath = "/tmp/discretescroll.err.log";
          };
        };
      };
    };
  };
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };
  services = {
    skhd.enable = true;
    yabai = {
      enable = true;
      enableScriptingAddition = true;
    };
  };
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      KeyRepeat = 5;
      InitialKeyRepeat = 30;
      NSAutomaticSpellingCorrectionEnabled = true;
    };
    dock.autohide = true;
    finder = {
      _FXShowPosixPathInTitle = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };
  };
  system.primaryUser = config.users.users.cl.name;
  system.stateVersion = 4;
  users.users.cl = {
    name = "cl";
    home = "/Users/cl";
  };
}
