## Celestial Wayland Compositor

# This is a dwl fork.
It is far from done yet, right now it offers: basic dwl functionality (tiling, floating, monocle layouts etc) and, infinite canvas support ported from vxwm (https://codeberg.org/wh1tepearl/vxwm).

Soon will be added basic wm functionality:
    run-time config
    gaps
    master layout extended control
    etc
    etc
    etc

Features that are in work right now:
    Hevel like zoom in/zoom out (i'll probably need to fork wlroots library)

Features that i'll consider adding:
    eye candy (animations, blur etc etc etc etc etc)

# To use this wayland compositor right now (You probably want to wait more for some basic stuff, but if you want, why not?)
install basic dwl deps (read their readme) and then:
    git clone https://github.com/celestial-wl/celestial.git
    cd celestial
    make
    sudo make install

Also try:

hevel wayland compositor: https://git.sr.ht/~dlm/hevel

5element: https://hg.sr.ht/~umix11/5element

vxwm: https://codeberg.org/wh1tepearl/vxwm.git

default dwl: https://codeberg.org/dwl/dwl.git
