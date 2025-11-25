{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager  }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        taps = [];
        brews = [ "cowsay" "aspell" ];
        casks = [ "freecad" ];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # Declare the user that will be running `nix-darwin`.
      users.users.jayeshv = {
        name = "jayeshv";
        home = "/Users/jayeshv";
      };

      system.primaryUser = "jayeshv";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration
      # for home-manager, don't change this!
      home.stateVersion = "25.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;
      fonts.fontconfig.enable = true;

      home = {
        packages = with pkgs; [
          python313
          python313Packages.ipython
          tmux
          emacs
          alacritty
          firefox
          # blender
          rustup
          dejavu_fonts
          nerd-fonts.cousine
          nodejs_24
          nodePackages.prettier
        ];

        file = {
          ".vimrc".source = ./vim_config;
          ".zshrc".source = ./zshrc.sh;
          ".alacritty.toml".source = ./alacritty.toml;
          ".gitconfig".source = ./gitconfig;
          ".gitignore".source = ./gitignore;
          ".emacs.d/init.el".source = ./emacs.el;
        };
      };
    };
  in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Jayeshs-MacBook-Pro
      darwinConfigurations."Jayeshs-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager  {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.jayeshv = homeconfig;
          }
        ];
      };
    };
}
