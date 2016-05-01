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



using BabeWidgets;

int main(string[] args) {
	
	Gtk.init(ref args); 
	Gst.init(ref args); 

	//set the babe styleshit 
	var css_provider = new Gtk.CssProvider();
	try
	{		
		css_provider.load_from_path("style.css");		
	}
	catch(GLib.Error e)
	{
		warning("Style sheet didn't load: %s", e.message);
	}
	
	Gtk.StyleContext.add_provider_for_screen(
		Gdk.Screen.get_default(),
		css_provider,
		Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
	
	//let's create the main window
	var main_window = new BabeWindow(); 
	
	//set babe app icon //needs work
	var app_icon = new Gdk.Pixbuf.from_file ("img/babe.svg");
	try 
	{
       main_window.set_icon(app_icon);
    
	} catch (GLib.Error e)
	{
		stderr.printf ("Could not load application icon: %s\n", e.message);
	}
		
	//show babe app	
	main_window.show_all();
	Gtk.main();	
	return 0;
}




	

