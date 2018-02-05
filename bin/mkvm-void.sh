#!/bin/sh
#
# vim: set ts=4 sw=4 et:
#
# mkvoidguest.sh

trap 'error_out $? $LINENO' INT TERM 0
umask 022

readonly REQUIRED_PKGS="base-voidstrap"
readonly PROGNAME=$(basename $0)

# Helper functions
info_msg() {
    printf "\033[1m$@\n\033[m"
}
die() {
    info_msg "ERROR: $@"
    error_out 1 $LINENO
}
print_step() {
    CURRENT_STEP=$((CURRENT_STEP+1))
    info_msg "[${CURRENT_STEP}/${STEP_COUNT}] $@"
}
error_out() {
    X=$1
    exit ${X:=0}
}

create_image_and_partition() {
    qemu-img create -f $IMAGETYPE $IMAGEDIR/$HOSTNAME.img $IMAGESIZE
    qemu-nbd --format=$IMAGETYPE --connect=$BLOCKDEVICE $HOSTNAME.img

    sfdisk $BLOCKDEVICE <<_EOF
,512,82
;
_EOF

    ls -la $BLOCKDEVICE*
}

usage() {
    cat <<_EOF
The $PROGNAME script generates a virtual machine with Void Linux installed.

Usage: $PROGNAME [options]
Options:
 -R <repo-url>      Use this XBPS repository (may be specified multiple times).
 -r <rootdir>       Rootdir where we are mounting the virtual machine.
 -d <blockdevice>   Block device to use for virtual machine.
 -k <keymap>        Default keymap to use (us if unset)
 -l <locale>        Default locale to use (en_US.UTF-8 if unset).
 -n <hostname>      Hostname to give this virtual machine.
 -s <imagesize>     Allocate this size for the image.
 -f <imagetype>     Type of image we want to create (raw if unset).
_EOF
    exit 1
}

#
# main()
#
while getopts "R:r:k:l:n:s:f:h" opt; do
    case $opt in
        R) XBPS_REPOSITORY="--repository=$OPTARG $XBPS_REPOSITORY";;
        r) ROOTDIR="$OPTARG";;
        d) BLOCKDEVICE="$OPTARG";;
        k) KEYMAP="$OPTARG";;
        l) LOCALE="$OPTARG";;
        n) HOSTNAME="$OPTARG";;
        s) IMAGESIZE="$OPTARG";;
        f) IMAGETYPE="$OPTARG";;
        h) usage;;
    esac
done
shift $((OPTIND - 1))

XBPS_REPOSITORY="$XBPS_REPOSITORY --repository=http://repo.voidlinux.eu/current"

# defaults
: ${BASE_ARCH:=$(xbps-uhelper arch 2>/dev/null || uname -m)}
: ${KEYMAP:=us}
: ${LOCALE:=en_US.UTF-8}
: ${IMAGESIZE:=10g}
: ${IMAGEDIR:=/vms/images}
: ${IMAGETYPE:=raw}

CURRENT_STEP=0
STEP_COUNT=9

# Check for root permissions.
if [ "$(id -u)" -ne 0 ]; then
    die "Must be run as root, exiting..."
fi

if [ -n "$ROOTDIR" ]; then
    die "rootdir must be specified..."
    usage
fi
if [ -n "$BLOCKDEVICE" ]; then
    die "blockdevice must be specified..."
    usage
fi

print_step "Create our image and partition disks..." 
create_image_and_partition
