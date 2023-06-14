#!/bin/bash

# deamon prepare

cp lang-switcher /usr/local/bin/lang-switcher

cat <<END > /Library/LaunchAgents/com.sarvarcorp.langswitcher.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>lang-switcher</string>
	<key>Program</key>
	<string>/usr/local/bin/lang-switcher</string>
	<key>OnDemand</key>
	<true/>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
	<key>Version</key>
	<string>63</string>
</dict>
</plist>
END
