#!/usr/bin/env sh

# Functions
ok() { echo -e '\e[32m'OK'\e[m'; } # Green
die() { echo -e '\e[1;31m'Error'\e[m'; exit 1; }

# Sanity check
[ $(id -g) != "0" ] && die "Script must be run as root."
#[ $# != "1" ] && die "Usage: $(basename $0) domainName"

if id -u "$1" >/dev/null 2>&1; then
  echo "User already in use!"
  exit 1
fi
adduser -G wwwuser -h /home/$1 -D $1
mkdir -p -v /home/$1
mkdir -p -v /home/$1/public_html
chown -R $1:wwwuser /home/$1
echo "$1:$2" | chpasswd

# Create nginx config file
cat > /etc/nginx/conf.d/$1.web02.cloudtek.dk.conf <<EOF
server {
    listen 80;
    index index.php index.html;
    server_name $1.web02.cloudtek.dk;
    root /home/$1/public_html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF

# Creating index.html file
cat > /home/$1/public_html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
      	<title>$1</title>
        <meta charset="utf-8" />
</head>
<body>
<h1>$1s web-page<h1>
<p>site under contruction</p>
</body>
</html>
EOF
