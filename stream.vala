/* Copyright 2016 Camilo Higuita(milohr)
*
* This file is part of Babe Music Player.
*
* Babe is free software: you can redistribute it
* and/or modify it under the terms of version 3 of the 
* GNU General Public License as published by the Free Software Foundation.
*
* Babe is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Babe. If not, see http://www.gnu.org/licenses/.
*/
using Gst;
using TagLib;

namespace BabeStream
{
	public class Stream	: GLib.Object
	{
		public string song_uri;
		public Gst.Element playbin;		 
		public Gst.Query query;
		private Gst.ClockTime duration;		
		private bool terminate;
		public bool next;
		public bool previous;
		private bool seek_enabled;
		private bool seek_done;
		private bool playing;			
		public	int64 start;
		public	int64 end;
	
		public Stream()
		{
			query = new Gst.Query.seeking (Gst.Format.TIME);
			this.seek_enabled = false;
			this.playing = false;
			this.terminate = false;
			this.seek_enabled = false;
			this.seek_done = false;
			this.duration = Gst.CLOCK_TIME_NONE;
			playbin = Gst.ElementFactory.make ("playbin", "bin");			
		}
		
		public void uri(string uri)
		{
			stdout.printf("uri---->: "+uri+"\n");
			song_uri=uri;
			start_stream(playbin);;
		}
		
		public void start_stream(Element playbin)
		{
			playbin.set_state(State.NULL);    
			playbin.set("uri",song_uri); 
			playbin.set_state (State.PLAYING);			
		}
		
		public void play_song()
		{
			playbin.set_state (State.PLAYING);
		}
		
		public void stop_stream()
		{
			playbin.set_state (State.NULL);
		}
		
		public void pause_song()
		{
			playbin.set_state (State.PAUSED);
		}		
		
		public int64 get_song_position () 
		{
			Gst.Format format = Gst.Format.TIME;			
			int64 pos;			
			playbin.query_position (format, out pos);			
			return pos;
		}
		
		public int64 get_song_duration () 
		{
			Gst.Format format = Gst.Format.TIME;
			int64 dur;
			playbin.query_duration (format, out dur);
		   		
			return dur;
		}
		
		public void seek (int64 seek_pos) 
		{
        playbin.seek_simple (Gst.Format.TIME, Gst.SeekFlags.FLUSH, seek_pos);
		}	
		
		public bool is_playing () {
        if (this.get_state() == Gst.State.PLAYING) {
            return true;
        }
        
        return false;
    }
    
      public Gst.State get_state () {
    
        Gst.State state;
        Gst.State pending;
    
        playbin.get_state (out state, out pending, 5 * Gst.SECOND);
        
        return state;
    }
    
    
    public void set_state (Gst.State state) {
        playbin.set_state (state);
    }
    
	}	
}
