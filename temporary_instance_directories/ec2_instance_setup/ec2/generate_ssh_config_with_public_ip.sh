#!/usr/bin/env bash
readonly server_public_ip=$1
readonly ssh_config_path=$2
cat <<EOF > "$ssh_config_path"
Host aws-test
    HostName $server_public_ip
EOF
