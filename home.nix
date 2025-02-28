{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    sway-contrib.grimshot
    wmenu
    wtype
  ];

  home.stateVersion = "24.11";

  programs.firefox.enable = true;

  programs.terminator.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  programs.wofi.enable = true;

  services.dunst.enable = true;

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };

  services.swayidle.enable = true;

  wayland.windowManager.sway = {
    config.terminal = "terminator";
    enable = true;
    systemd.enable = false; # we are using uwsm
  };
}
