# Maintainer: Grégoire Seux <grego_aur@familleseux.net>
# Contributor: Dean Galvin <deangalvin3@gmail.com>
# Contributor: NicoHood <archlinux {cat} nicohood {dog} de>

pkgname="home-assistant"
pkgdesc='Open-source home automation platform running on Python 3'
pkgver=0.64.0
pkgrel=2
url="https://home-assistant.io/"
license=('APACHE')
arch=('any')
replaces=('python-home-assistant')
makedepends=('python-setuptools')
# NB: this package will install additional python packages in /var/lib/hass/lib depending on components present in the configuration files.
depends=('python' 'python-pip' 'python-requests>=2.14.2' 'python-yaml' 'python-pytz>=2017.2'
         'python-vincenty' 'python-voluptuous>=0.11.1' 'python-netifaces'
         'python-webcolors' 'python-async-timeout>=2.0.0' 'python-aiohttp=2.3.10' 'python-aiohttp-cors>=0.5.3'
         'python-jinja>=2.9.5' 'python-yarl>=1.1.0' 'python-chardet>=3.0.4' 'python-astral>=1.5' 'python-certifi' 'python-attrs'
         'python-multidict>=4.0')
optdepends=('git: install component requirements from github'
            'net-tools: necessary for nmap discovery')
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/${pkgname}/${pkgname}/archive/${pkgver}.tar.gz"
        "home-assistant.service"
        "home-assistant.sysusers"
        "home-assistant-tmpfile.conf"
        "hass.install")
sha512sums=('9a1b7f494897041e2361d4e56bd073c7b6b6120db408deaf0149f3cc72048f02b6e9e419d77de551c462d6c840c3111170a120dd50e1fe790110bcb2dd84c444'
            'fe96bd3df3ba666fd9f127c466d1dd1dd7314db2e57826a2b319c8a0bfad7aedeac398e748f93c6ecd9c2247ebbae196b8b0e7263b8681e2b7aeab6a8bfeab80'
            '100665ac35370c3ccec65d73521568de21cebf9e46af364124778861c94e338e32ad9abb675d3917f97d351dd7867e3ab2e80c26616330ae7cf0d9dc3f13369b'
            '8babcf544c97ec5ad785014f0b0d5dca556a2f5157dadcbe83d49d4669b74f6349e274810ec9a028fcec208c6c8fbbe6b3899d2933b56163b9e506570879a3ad'
            'e73e363b5eea1a5b2fdb2ba91c17672356b9accd14ecae66ee713be889abe9bbe6a4d2f55d106f4dc9430246326ace4eb29642e9fed1048462b10c42db14a826')
#validpgpkeys=('') # TODO https://github.com/home-assistant/home-assistant/issues/9487
install='hass.install'

prepare() {
  cd "${srcdir}/${pkgname}-${pkgver}"
  # TODO remove in future versions https://github.com/home-assistant/home-assistant/issues/9525
  replace '==' '>=' setup.py

  # typing package is a backport of standard library < 3.5
  replace 'typing>=3,<4' '' setup.py

  # Remving theese as they break 0.64 with yarl-1.10 and aiohttp-2.3.10
  # replace 'aiohttp>=2.3.10' 'aiohttp>=2.3.9' setup.py

  # echo Patching for home-assistant/home-assistant#11906
  # sed -i 's/from yarl import unquote/from yarl import URL/' homeassistant/components/http/static.py
  # sed -i "s/unquote(request.match_info\['filename'\])/URL(request.match_info['filename'], encoded=True).path/" homeassistant/components/http/static.py
}

replace() {
  pattern=$1
  substitute=$2
  file=$3
  echo -n "Replacing '$pattern' by '$substitute' in $file..."
  if grep -q $pattern $file && sed -i "s/$pattern/$substitute/" $file; then
    echo "DONE"
  else
    echo "FAILED"
    depname=$(echo $pattern | sed 's/[>=<].*$//')
    echo Current line in $file:
    grep $depname $file
    exit 1
  fi
}

package() {
  install -Dm644 home-assistant.service "${pkgdir}/usr/lib/systemd/system/home-assistant.service"
  install -Dm644 home-assistant.sysusers "${pkgdir}/usr/lib/sysusers.d/hass.conf"
  install -Dm644 home-assistant-tmpfile.conf "${pkgdir}/usr/lib/tmpfiles.d/hass.conf"

  cd "${srcdir}/${pkgname}-${pkgver}"
  python setup.py install --root="$pkgdir" --prefix=/usr --optimize=1
}
