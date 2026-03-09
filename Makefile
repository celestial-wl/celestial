.POSIX:
.SUFFIXES:

include config.mk

VPATH = src

# flags for compiling
CELESTIALCPPFLAGS = -I. -DWLR_USE_UNSTABLE -D_POSIX_C_SOURCE=200809L \
	-DVERSION=\"$(VERSION)\" $(XWAYLAND)
CELESTIALDEVCFLAGS = -g -Wpedantic -Wall -Wextra -Wdeclaration-after-statement \
	-Wno-unused-parameter -Wshadow -Wunused-macros -Werror=strict-prototypes \
	-Werror=implicit -Werror=return-type -Werror=incompatible-pointer-types \
	-Wfloat-conversion

# CFLAGS / LDFLAGS
PKGS      = wayland-server xkbcommon libinput $(XLIBS)
CELESTIALCFLAGS = `$(PKG_CONFIG) --cflags $(PKGS)` $(WLR_INCS) $(CELESTIALCPPFLAGS) $(CELESTIALDEVCFLAGS) $(CFLAGS)
LDLIBS    = `$(PKG_CONFIG) --libs $(PKGS)` $(WLR_LIBS) -lm $(LIBS)

all: celestial
celestial: celestial.o util.o
	$(CC) celestial.o util.o $(CELESTIALCFLAGS) $(LDFLAGS) $(LDLIBS) -o $@
celestial.o: celestial.c client.h config.h config.mk cursor-shape-v1-protocol.h \
	pointer-constraints-unstable-v1-protocol.h wlr-layer-shell-unstable-v1-protocol.h \
	wlr-output-power-management-unstable-v1-protocol.h xdg-shell-protocol.h
util.o: util.c util.h

# wayland-scanner is a tool which generates C headers and rigging for Wayland
# protocols, which are specified in XML. wlroots requires you to rig these up
# to your build system yourself and provide them in the include path.
WAYLAND_SCANNER   = `$(PKG_CONFIG) --variable=wayland_scanner wayland-scanner`
WAYLAND_PROTOCOLS = `$(PKG_CONFIG) --variable=pkgdatadir wayland-protocols`

cursor-shape-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/staging/cursor-shape/cursor-shape-v1.xml $@
pointer-constraints-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		$(WAYLAND_PROTOCOLS)/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml $@
wlr-layer-shell-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) enum-header \
		protocols/wlr-layer-shell-unstable-v1.xml $@
wlr-output-power-management-unstable-v1-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		protocols/wlr-output-power-management-unstable-v1.xml $@
xdg-shell-protocol.h:
	$(WAYLAND_SCANNER) server-header \
		$(WAYLAND_PROTOCOLS)/stable/xdg-shell/xdg-shell.xml $@

config.h:
	cp config.def.h $@
clean:
	rm -f celestial *.o *-protocol.h

dist: clean
	mkdir -p celestial-$(VERSION)
	cp -R LICENSE* Makefile client.h config.def.h \
		config.mk protocols celestial.c util.c util.h celestial.desktop \
		celestial-$(VERSION)
	tar -caf celestial-$(VERSION).tar.gz celestial-$(VERSION)

	rm -rf celestial-$(VERSION)

install: celestial

	mkdir -p $(DESTDIR)$(PREFIX)/bin
	rm -f $(DESTDIR)$(PREFIX)/bin/celestial
	cp -f celestial $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/celestial
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	mkdir -p $(DESTDIR)$(DATADIR)/wayland-sessions
	cp -f celestial.desktop $(DESTDIR)$(DATADIR)/wayland-sessions/celestial.desktop
	chmod 644 $(DESTDIR)$(DATADIR)/wayland-sessions/celestial.desktop
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/celestial \
		$(DESTDIR)$(DATADIR)/wayland-sessions/celestial.desktop

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CPPFLAGS) $(CELESTIALCFLAGS) -o $@ -c $<
