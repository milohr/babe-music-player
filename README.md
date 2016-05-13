# babe-music-player
Babe Music Player - tiny desktop player

To compile get into the folder and run:

***Install dependencies:***

sudo apt-get install valac libgee-0.8-dev libgtk-3-dev libsoup2.4-dev libtagc0-dev libtag1-dev libges-1.0-dev libnotify-dev

sudo ln -s /usr/share/vala/vapi/gee-0.8.vapi /usr/share/vala/vapi/gee-1.0.vapi

***Compile:***

valac --pkg gstreamer-1.0 --pkg gtk+-3.0 --pkg taglib_c --pkg gee-1.0 --pkg libxml-2.0 --pkg libsoup-2.4 --pkg libnotify babe.vala stream.vala lastfm.vala widgets.vala LyricFetcher.vala

***and run:***

./babe

![alt tag](https://raw.githubusercontent.com/milohr/babe-music-player/master/Screenshot%20from%202016-05-01%2020%3A07%3A41.png) ![alt tag](https://raw.githubusercontent.com/milohr/babe-music-player/master/Screenshot%20from%202016-05-01%2020%3A08%3A06.png)

Soon I'll make it easier to compile and create some testing packages.
