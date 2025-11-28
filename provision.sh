#!/bin/bash
set -e

# Update
apt-get update -y
apt-get upgrade -y

# Install basics
apt-get install -y openjdk-11-jdk git curl gnupg2 unzip rsync

# Install Nginx
apt-get install -y nginx

# Create site directory
mkdir -p /var/www/html/site
chown -R www-data:www-data /var/www/html/site
chmod -R 755 /var/www/html/site

# Configure nginx simple site (serve /var/www/html/site)
cat > /etc/nginx/sites-available/mon-site <<'NGINX'
server {
    listen 80 default_server;
    server_name _;

    root /var/www/html/site;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/mon-site /etc/nginx/sites-enabled/mon-site
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx

# Install Jenkins (LTS)
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list
apt-get update -y
apt-get install -y jenkins

# Ensure jenkins can deploy: add jenkins user to www-data and allow rsync/cp via sudo without password
usermod -aG www-data jenkins

# Allow limited sudo for jenkins (NOPASSWD for rsync, cp, chown, chmod, systemctl)
cat > /etc/sudoers.d/jenkins <<'SUDO'
jenkins ALL=(ALL) NOPASSWD: /usr/bin/rsync, /bin/cp, /bin/chown, /bin/chmod, /bin/systemctl
SUDO
chmod 440 /etc/sudoers.d/jenkins

# Start & enable services
systemctl enable --now jenkins
systemctl enable --now nginx

# (Optional) put a placeholder index so you see something before first deploy
echo "<html><body><h1>Placeholder - site not yet déployé</h1></body></html>" > /var/www/html/site/index.html
chown -R www-data:www-data /var/www/html/site
