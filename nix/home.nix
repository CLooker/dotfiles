# https://nix-community.github.io/home-manager/options.xhtml
{ config, lib, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  x86_64LinuxPackages = [];
  aarch64DarwinPackages = with pkgs; [
    betterdisplay
    skhd
    toybox
    utm
    uutils-coreutils-noprefix # replaces bsd coreutils
    yabai
    zoom-us
  ];
  aarch64LinuxPackages = with pkgs; [ ];
in
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.homeDirectory = if system == "aarch64-darwin" then "/Users/cl" else "/home/cl";
  home.username = "cl";

  nixpkgs.config.allowUnfree = true;

    #home.activation = {
    #  install_nightly_nvim = lib.hm.dag.entryAfter ["post-installPackages"] ''
    #    PATH="${config.home.path}/bin:$PATH" 
    #    run ${builtins.toPath ./../dotfiles/workspace/script/install_nightly_nvim} -c
    #  '';
    #};

  home.packages =
    with pkgs;
    [
      cargo
      curl
      gotools
      gradle
      jetbrains.idea-community
      lua
      maven
      neofetch
      nixfmt-rfc-style
      podman
      shellcheck
      shfmt
      tree
      unixtools.ifconfig
      unixtools.netstat
      unzip
      xclip
      yq-go

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ (if system == "x86_64-linux" then x86_64LinuxPackages else [ ])
    ++ (if system == "aarch64-darwin" then aarch64DarwinPackages else [ ])
    ++ (if system == "aarch64-linux" then aarch64LinuxPackages else [ ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # trick to place whole folder into home instead of importing individual files
  home.file."foo/.." = {
    target = "foo/..";
    source = ./foo/../../dotfiles;
    recursive = true;
  };

  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  # # symlink to the Nix store copy.
  # ".screenrc".source = dotfiles/screenrc;

  # # You can also set the file content immediately.
  # ".gradle/gradle.properties".text = ''
  #   org.gradle.console=verbose
  #   org.gradle.daemon.idletimeout=3600000
  # '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cl/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = "1"; # to use my bashrc in nix-shell
  };

  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;

  programs.git = {
    enable = true;
    userEmail = "Chad.Looker@gmail.com";
    userName = "Chad Looker";
  };

  programs.go.enable = true;

  programs.home-manager.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk24;
  };

  programs.jq.enable = true;

  programs.neovim = {
    enable = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      (blink-cmp.overrideAttrs (_final: prev: {
        dependencies = (prev.dependencies or [ ]) ++ [ friendly-snippets ]; 
      }))
      (oil-nvim.overrideAttrs (_final: prev: {
        dependencies = (prev.dependencies or [ ]) ++ [ nvim-web-devicons ]; # makes icons visible to oil-nvim 
      }))
      lualine-nvim
      nvim-lspconfig
      telescope-fzf-native-nvim
      telescope-nvim
      tokyonight-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (ps: [ ps.bash ps.java ps.javascript ps.lua ]))
    ];
    extraPackages = with pkgs; [
      gopls
      lua-language-server
      nodePackages_latest.bash-language-server
    ];
  };
}
