{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sway-contrib.grimshot
    wmenu
  ];

  home.stateVersion = "24.11";

  programs.terminator.enable = true;

  programs.wofi.enable = true;

  services.dunst.enable = true;

  services.swayidle.enable = true;

  wayland.windowManager.sway = {
    config.terminal = "terminator";
    enable = true;
    systemd.enable = false; # we are using uwsm
  };
}
