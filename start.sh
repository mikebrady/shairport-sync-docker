#!/bin/sh

set -e

rm -rf /var/run/dbus.pid
#mkdir -p /var/run/dbus

dbus-uuidgen --ensure
dbus-daemon --system

avahi-daemon --daemonize --no-chroot

su-exec shairport-sync shairport-sync "$@"
