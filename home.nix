{
  home.stateVersion = "24.11";

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = false; # we are using uwsm
  };
}
