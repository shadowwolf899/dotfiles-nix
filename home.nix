{pkgs, ...}: {
  home.username = "jericho";
  home.homeDirectory = "/home/jericho";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    cargo
    gitui
    openscad
    git
    gnumake
    just
    gcc
    rustc
    pkg-config
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Jericho Keyne";
    userEmail = "jerichokeyne@gmail.com";

    includes =
      [{
        condition = "gitdir/i:~/work*/**";
        contents = {
          user = {
            name = "Jericho Keyne";
            email = "jkeyne@opentext.com";
          };
        };
      }];

    extraConfig = {
      url = {
        "ssh://git@github.houston.softwaregrp.net" = {
          insteadOf = "https://github.houston.softwaregrp.net";
        };
      };
    };
  };
}
