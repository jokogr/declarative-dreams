{
  home.stateVersion = "24.11";

  programs.terminator.enable = true;

  services.dunst.enable = true;

  wayland.windowManager.sway = {
    config.terminal = "terminator";
    enable = true;
    systemd.enable = false; # we are using uwsm
  };
}
