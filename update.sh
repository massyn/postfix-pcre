#!/usr/bin/bash

# -- does this system have postfix installed?  If not, let's just stop right here

dpkg -l postfix > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo No postfix found... Stopping...
	exit 1
fi

# -- if we got this far, let's try to install postfix pcre

dpkg -l postfix-pcre > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	apt-get install postfix-pcre -y
else
	echo Postfix pcre already installed...
fi

# -- copy the files across
cp body_checks /etc/postfix/body_checks
cp header_checks /etc/postfix/header_checks

# -- do some basic configuration
postconf -e body_checks=pcre:/etc/postfix/body_checks
postconf -e header_checks=pcre:/etc/postfix/header_checks
postmap /etc/postfix/body_checks
postmap /etc/postfix/header_checks
postfix reload