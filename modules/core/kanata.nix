
{ ... }:
{
  # Remap CAPS lock to ESC
  services.udev.extraHwdb = ''
    evdev:atkbd:*
      KEYBOARD_KEY_3a=esc
  '';
  services.xserver = {
    xkb.options = "caps:swapescape";
  };
}
