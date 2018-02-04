#!/bin/bash

svcln() {
	[ -L /var/service/$1 ] || ln -s /etc/sv/$1 /var/service/
}

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "en_US.UTF-8 UTF-8" > /etc/default/libc-locales
xbps-reconfigure -f glibc-locales

cat << EOF > /etc/rc.conf
HARDWARECLOCK="UTC"
TIMEZONE=America/Detroit
KEYMAP=
EOF

xbps-install -Sy openntpd socklog socklog-void lsof htop \
	tmux vim git fzf tree xtools qemu curl oksh

# Setup logging
svcln socklog-unix
svcln nanoklogd
usermod -aG socklog asenchi

# Setup ntpd
svcln openntpd
cat << EOF > /etc/ntpd.conf
servers pool.ntp.org
sensor *
constraints from "https://www.google.com"
EOF
ntpd -n && sv restart openntpd

# Ensure sshd is logging
cat << EOF > /etc/sv/sshd/run
#!/bin/sh
ssh-keygen -A >/dev/null 2>&1 # Will generate host keys if they don't already exist
[ -r conf ] && . ./conf
exec 2>&1
exec /usr/bin/sshd -De $OPTS
EOF

mkdir -p /etc/sv/sshd/log
cat << EOF > /etc/sv/sshd/log/run
#!/bin/sh
[ -d /var/log/sshd ] || mkdir -p /var/log/sshd
exec chpst -u root:adm svlogd -t /var/log/sshd
EOF

svcln sshd
sv restart sshd

# Ensure we install only what we need for this host, and not a generic setup
echo 'hostonly="yes"' >> /etc/dracut.conf

kernel=$(xbps-query --regex -Rs '^linux[[:digit:]]\.[-0-9\._]*$' | cut -f2 -d' ' | sort -V | tail -n1)
xbps-reconfigure -f ${kernel}

mkdir -p /etc/modules-load.d
cat << EOF > nbd.conf
# load qemu-nbd
nbd
EOF

xbps-alternatives -g sh -s oksh
cat << EOF > /etc/xbps.d/void-virtualpkgs.conf
virtualpkg=shell:ksh
EOF

# Update our man page database
makewhatis /usr/share/man
