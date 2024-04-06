#!/bin/bash
# SPDX-License-Identifier: 0BSD

set -eu
src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
. "$src/var/rc"
bind_src="$(sed -e 's/\\\"/""/g' <<< "$src/var")"
podman run --rm "--mount=type=bind,src=$bind_src,dst=/host,relabel=private" -i -- "$image" sudo bash -es -- "$dnf" <<'EOF'
rm -fr /host/root
dnf install --installroot=/host/root --setopt=cachedir=/host/cache --setopt=keepcache=1 -y toolbox-support "$@"
EOF
podman build -t "$tag" "$src"
toolbox rm -f -- "$tag"
toolbox create -i "$tag"
