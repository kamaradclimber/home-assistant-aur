#!/usr/bin/bash

set -ex

echo "Building archlinux package within docker"

# cleaning
rm -rf home-assistant-*pkg.tar.*
rm -rf src/*
rm -rf 0.*.tar.gz

if [[ -n "$UPDATE" ]]; then

  pacman -S --noconfirm ruby

  LAST_VERSION=$(ruby -r "net/http" -r "uri" -r "json" -e 'uri = URI.parse("https://api.github.com/repos/home-assistant/home-assistant/releases"); response = Net::HTTP.get_response(uri); if response.code.to_i != 200 then puts response.code.inspect; exit(1); end; puts JSON.parse(response.body).first["name"]')

  VERSION=$1
  echo "Will update to ${VERSION:=$LAST_VERSION}"
  sed -i -re "s/^pkgver=.*$/pkgver=$VERSION/" PKGBUILD
  # Reset release to 1
  sed -i -re "s/^pkgrel=.*$/pkgrel=1/" PKGBUILD

  sudo -u build makepkg --verifysource || echo "Will now update checksums"

  sudo -u build updpkgsums

  sudo -u build makepkg --printsrcinfo > .SRCINFO
fi

# install 3 known aur dependencies
sudo -u build bash -c "cd /tmp && yaourt -S --noconfirm --needed python-vincenty python-voluptuous python-aiohttp-cors python-astral"


sudo -u build makepkg -s -i --noconfirm
echo "Package built!"

sudo -u hass /usr/bin/hass --config /var/lib/hass/ --daemon

echo "Sleeping 60seconds..."
echo "Checking errors"
errors=$(cat /var/lib/hass/home-assistant.log | wc -l)

if [[ "$errors" -gt "0" ]]; then
  cat "Errors:"
  cat /var/lib/hass/home-assistant.log
  exit 1
fi


