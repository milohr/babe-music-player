using Gtk;
using TagLib;


namespace BabeList
{
	
 private const Gtk.TargetEntry[] targets = {
        {"text/uri-list",0,0}
    };

public class BList : Gtk.ScrolledWindow
{
	public int c;
	private Gtk.ListStore main_list;
	private Gtk.CellRendererText main_list_cell;
	private Gtk.TreeView main_list_view;
	public Gtk.TreeIter iter;
	private Gtk.FileChooserDialog chooser;
	public Gtk.Box box;
	public Gtk.EventBox add_music_event;
	public Gtk.Stack stack;
	public BList()
	{			
			
		
		Object(hadjustment: null, vadjustment: null);
		c=0;
		Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
		this.drag_data_received.connect(on_drag_data_received);

		main_list = new Gtk.ListStore (5, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
		main_list_cell = new Gtk.CellRendererText ();
		main_list_view= new Gtk.TreeView.with_model (main_list);

		main_list_view.insert_column_with_attributes (-1, "Title", main_list_cell, "text", 0);
			
		main_list_view.set_grid_lines (TreeViewGridLines.BOTH);
		main_list_view.set_reorderable(true);
		main_list_view.set_headers_visible(false);
		main_list_view.set_enable_search(true);
		
		var label=new Gtk.Label("Add Music");// use this in future if i can make it use the font wanted
		
		var add_music_img = new Gtk.Image();
		add_music_img.set_from_file("img/add.png");
		
		add_music_event = new Gtk.EventBox();
		add_music_event.add(add_music_img);
		add_music_event.button_press_event.connect (() => {
					on_open();
					return true;
		});
		
		stack= new Gtk.Stack();
		stack.set_vexpand(true);//main list
        stack.set_vexpand(true);//add music event/message
		
		stack.add_named(add_music_event, "add");
		stack.add_named(main_list_view, "list");

		GLib.Timeout.add (1000, (SourceFunc) this.check_list);

		this.set_min_content_height(200);
		this.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		this.add(stack);
	}
		
	public void on_open()
	{
	 	chooser = new Gtk.FileChooserDialog (
				"Select your favorite file", null, Gtk.FileChooserAction.OPEN,
				"_Cancel",
				Gtk.ResponseType.CANCEL,
				"_Open",
				Gtk.ResponseType.ACCEPT);

		chooser.select_multiple = true;
		Gtk.FileFilter filter = new Gtk.FileFilter ();
		filter.set_filter_name ("Audio");
		filter.add_pattern ("*.mp3");
		filter.add_pattern ("*.flac");
		chooser.add_filter (filter);

		if (chooser.run () == Gtk.ResponseType.ACCEPT)
		{
			SList<string> uris = chooser.get_uris ();
			//stdout.printf ("Selection on_open:\n");
			foreach (unowned string uri in uris)
			{
				populate(uri);
			}			
		}

		chooser.close ();
	}
	
	public void modify_c(int x)
	{
		c=x;		
	}
	
	public int get_c()
	{
		return c;
	}
	public async void populate(string uri)
	{	 
		var file = GLib.File.new_for_uri (uri); //check if file exists
		var type = GLib.ContentType.guess(uri, null,null);	//check if file is audio file	
		
		if (file.query_exists()&& type.contains("audio"))
		{
			main_list.append (out iter);
			main_list.set (iter, 0, get_song_info(uri).tag.title+"\nby "+ get_song_info(uri).tag.artist, 1, get_song_info(uri).tag.artist, 2, uri, 3,get_song_info(uri).tag.album,4,get_song_info(uri).tag.title);
			c++;
        }else
        {
			warning("no existe");			
		}
	
	}
		
	public TagLib.File get_song_info(string uri)//it actually turns a uri into a path to be able to get the tags
	{					
		var gfile = GLib.File.new_for_uri (uri);
		string nm=gfile.get_path() ;
		var info =  new TagLib.File(nm);
		return info;
	}	
		
	public Gtk.TreeView get_treeview()
	{
		return main_list_view;
	}	
	
	public Gtk.ListStore get_liststore()
	{
		return main_list;
	}
		
	
	public bool list_is_empty()
	{
		if(c==0)
		{
			return true;
			
		}else
		{
			print(c.to_string()+"//");
			return false;
		}
		
	}
    
    public void check_list()
    {
		if(list_is_empty())
		{
			stack.set_visible_child_name("add");
			
		}else
		{
			stack.set_visible_child_name("list");
		}
		
	}
    
    private async void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, 
                                        Gtk.SelectionData data, uint info, uint time) 
    {
        //loop through list of URIs
        foreach(string uri in data.get_uris ())
        {
			var file = GLib.File.new_for_uri (uri);
			if(file.query_file_type (0) == GLib.FileType.REGULAR ) 
			{
				populate (uri);
			}
			if(file.query_file_type (0) == GLib.FileType.DIRECTORY )
			{
				print("es un directorio");
				try 
				{
					var directory = GLib.File.new_for_uri (uri);			
					var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
					FileInfo file_info;
					while ((file_info = enumerator.next_file ()) != null) 
					{        
						GLib.File child = enumerator.get_child (file_info);
						populate (child.get_uri());				
					}

				} catch (Error e)
				{
					stderr.printf ("Error: %s\n", e.message);
      
				} 				
			}
        }

        Gtk.drag_finish (drag_context, true, false, time);
    }

	
}
}



