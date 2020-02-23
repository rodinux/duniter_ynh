#/bin/bash

INSTALL_DUNITER_DEBIAN_PACKAGE () {
        version="v1.7.18"
	if [ $arch == "x64" ]; then
		url_base="https://git.duniter.org/nodes/typescript/duniter/-/jobs/21913/artifacts/raw/work/bin/"
	else
		url_base="https://jytou.fr/duniter/"
	fi

        deb="duniter-server-$version-linux-$arch.deb"
	url="${url_base}${deb}"

	# Retrieve debian package and install it
	wget -nc --quiet $url -P /tmp
	deb_path="/tmp/$deb"
	dpkg -i $deb_path > /dev/null
	rm -f $deb_path
}

INSTALL_SYSTEMD () {
	cp ../conf/duniter.service /lib/systemd/system/duniter.service
	systemctl enable duniter.service
}

CONFIGURE_DUNITER () {
	duniter config --ipv4 127.0.0.1 --port $port --remoteh $domain --remotep 80 --noupnp
	duniter config --addep "BMAS $domain 443"
	duniter config --ws2p-host 127.0.0.1 --ws2p-port 20901 --ws2p-remote-host $domain --ws2p-remote-port 443 --ws2p-noupnp
}

CONFIG_SSOWAT () {
	# Add admin to the allowed users
	yunohost app addaccess $app -u $admin

	# Protect senstive sub-routes
	ynh_app_setting_set "$app" protected_uris "/webui","/webmin"

	# Duniter is public app, with only some parts restricted in nginx.conf
	ynh_app_setting_set "$app" unprotected_uris "/","/modules"

	# Set URL redirection from root to webadmin
	ynh_app_setting_set "$app" redirected_urls "{'$domain/':'$domain/webui'}"
}

CONFIG_NGINX () {
	nginx_conf="../conf/nginx.conf"
	sed -i "s@YNH_EXAMPLE_PORT@$port@" $nginx_conf
	sed -i "s@YNH_EXAMPLE_DOMAIN@$domain@" $nginx_conf
	cp $nginx_conf /etc/nginx/conf.d/$domain.d/$app.conf
	service nginx reload
}

REMOVE_DUNITER () {
	# Stop duniter daemon if running
	duniter status
	if [ `echo "$?"` == 0 ]; then
	    duniter stop
	fi

	# Remove Duniter package
	dpkg -r duniter
}
