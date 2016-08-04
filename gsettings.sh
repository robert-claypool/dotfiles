# disable all power buttons because they a terribly placed on some keyboards
# accidental power changes are not fun

# disable the hibernate button
# default value is "hibernate"
gsettings set org.gnome.settings-daemon.plugins.power button-hibernate "nothing"
# disable the power button
# default value is "suspend"
gsettings set org.gnome.settings-daemon.plugins.power button-power "nothing"
# disable the sleep button
# default value is "hibernate"
gsettings set org.gnome.settings-daemon.plugins.power button-sleep "nothing"
# disable the suspend button
# default value is "suspend"
gsettings set org.gnome.settings-daemon.plugins.power button-suspend "nothing"
