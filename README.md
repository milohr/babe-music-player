# babe-music-player
Babe Music Player - tiny desktop player

To compile get into the folder and run:

valac --pkg gstreamer-1.0 --pkg gtk+-3.0 --pkg taglib_c --pkg gee-1.0 --pkg libxml-2.0 --pkg libsoup-2.4 babe.vala stream.vala lastfm.vala widgets.vala

Soon I'll make it easier to compile and create some testing packages.

There's still a lot to do:

1-Implement the creation of playlists

2-Implement the info view with:
  -artist info
  -song lyrics
  -sililar artists ...etc
  
3-Implement the queue view

4-Create a Youtube extension to babe music videos

  (maybe using youtube-dll to download them? or maybe a direct stream?) check how illegal that would be.
  4.1 maybe some other extensions for another online music services... so maybe a chrome extension. 
  
5-Implement the sguffle mode (work in progress)

6-Be able to quickly open files with babe (not idea how-investigating) - start them on autoplay

7-Improve design

8-Fix bunch or minor bugs(like selection color...)





