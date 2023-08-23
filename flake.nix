{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./hardware-configuration.nix
          ({ pkgs, ... }: {
            system.stateVersion = "23.11";
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            networking.networkmanager.enable = true;
            i18n.defaultLocale = "en_US.UTF-8";
            i18n.extraLocaleSettings = {
              LC_ADDRESS = "en_US.UTF-8";
              LC_IDENTIFICATION = "en_US.UTF-8";
              LC_MEASUREMENT = "en_US.UTF-8";
              LC_MONETARY = "en_US.UTF-8";
              LC_NAME = "en_US.UTF-8";
              LC_NUMERIC = "en_US.UTF-8";
              LC_PAPER = "en_US.UTF-8";
              LC_TELEPHONE = "en_US.UTF-8";
              LC_TIME = "en_US.UTF-8";
            };

            # Enable the GNOME Desktop Environment.
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;
            # Configure keymap in X11
            services.xserver = {
              enable = true;
              layout = "us";
              xkbVariant = "";
            };

            # Enable CUPS to print documents.
            services.printing.enable = true;

            # Enable sound with pipewire.
            sound.enable = true;
            hardware.pulseaudio.enable = false;
            security.rtkit.enable = true;
            services.pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
              jack.enable = true;
            };

            # Define a user account. Don't forget to set a password with ‘passwd’.
            users.users.jericho = {
              isNormalUser = true;
              description = "Jericho Keyne";
              extraGroups = [ "networkmanager" "wheel" "docker" ];
              packages = with pkgs; [
                firefox
                thunderbird
                docker-compose
              ];
            };

            # Allow unfree packages
            nixpkgs.config.allowUnfree = true;

            # List packages installed in system profile. To search, run:
            # $ nix search wget
            environment.systemPackages = with pkgs; [
              vim
              neovim
              wget
              helix
            ];
            time.timeZone = "America/New_York";
            virtualisation.docker.enable = true;
            #virtualisation.podman = {
            #  enable = true;
            #  dockerCompat = true;
            #  dockerSocket.enable = true;
            #  autoPrune.enable = true;
            #};
          })
        ];
    };
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "jericho" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home.nix ./helix.nix ];
      };
      "runner" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home.nix ./helix.nix ];
      };
    };

  };
}
