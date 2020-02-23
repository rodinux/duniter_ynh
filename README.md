# Duniter package for YunoHost
- [Duniter project](https://duniter.org)
- [YunoHost project](https://yunohost.org)

## Requirements
- Debian Stretch
- YunoHost ≥ 3.0
- `x64` or `armlv7` architecture
- 200Mo free RAM
- A dedicated domain name to install the app on root path. For instance, `duniter.domain.tld`.
- A YunoHost user which will have access the web admin.

## Install and upgrade
You shall add the application community list into your instance in order to install it and benefit from upgrades:
```bash
sudo yunohost app fetchlist -n community -u https://app.yunohost.org/community.json
sudo yunohost app install duniter
sudo yunohost app upgrade duniter
```
Be carefull when installing applications from the community list.

## Configurations
- In order to compute blocks you will have to set your member credentials with `duniter wizard key` or from the webadmin.
- The BMA API is accessible from `https://duniter.domain.tld/` if enabled.

## Cesium
Cesium is a wallet webapp. There is currently two ways to install it:
- [With the YunoHost app](https://github.com/YunoHost-Apps/cesium_ynh)

## License
This package and the Duniter software are under GNU AGPL v.3.
