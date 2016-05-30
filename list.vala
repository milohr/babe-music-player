using Gtk;
using TagLib;
using BabeList;
using BabeStream;

namespace BabeList
{
	
 private const Gtk.TargetEntry[] targets = {
        {"text/uri-list",0,0}
    };

public class BList : Gtk.ScrolledWindow
{
	private Stream stream; 
	private Gtk.ListStore main_list;
	private Gtk.CellRendererText main_list_cell;
	private Gtk.TreeView main_list_view;
	public Gtk.TreeIter iter;
	
	public BList()
	{			
			
		Object(hadjustment: null, vadjustment: null);
		 Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
this.drag_data_received.connect(on_drag_data_received);

		main_list = new Gtk.ListStore (5, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
		main_list_cell = new Gtk.CellRendererText ();
		main_list_view= new Gtk.TreeView.with_model (main_list);

		main_list_view.insert_column_with_attributes (-1, "Title", main_list_cell, "text", 0);
			
		this.set_min_content_height(200);
		this.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		this.add (main_list_view);
		stream = new Stream();
	}
		
	public async void populate(string uri)
	{					
		 		
    var file = GLib.File.new_for_uri (uri); //check if file exists
		var type = GLib.ContentType.guess(uri, null,null);	//check if file is audio file	
		
		if (file.query_exists()&& type.contains("audio"))
		{
			main_list.append (out iter);
			main_list.set (iter, 0, get_song_info(uri).tag.title+"\nby "+ get_song_info(uri).tag.artist, 1, get_song_info(uri).tag.artist, 2, uri, 3,get_song_info(uri).tag.album,4,get_song_info(uri).tag.title);
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
		
public void on_row_activated (Gtk.TreeView treeview , Gtk.TreePath path, Gtk.TreeViewColumn column) //double click starts playback
	{
		Gtk.TreeIter iter;
			
		string title, artist, song, album;
		var model=treeview.get_model();

        if (treeview.model.get_iter (out iter, path)) {
		model.get (iter,
                        4, out title,
						1, out artist,
						2, out song,
						3, out album);

		stream.uri(song);
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
				as.populate (uri);
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
						as.populate (child.get_uri());				
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



BList as ;



public static int main(string[] args)
{
Gtk.init(ref args);
Gst.init(ref args);
var window = new Gtk.Window();
as = new BList();

as.get_treeview().set_grid_lines (TreeViewGridLines.BOTH);
		as.get_treeview().set_reorderable(true);
		as.get_treeview().set_headers_visible(false);
as.get_treeview().set_enable_search(true);

as.get_treeview().row_activated.connect(as.on_row_activated);

as.show_all();
var caja = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
var entry = new Gtk.Entry();
entry.set_placeholder_text("Ingresar");
entry.activate.connect(()=>{
	as.populate(entry.get_text());
	
	});
	
caja.add(as);
caja.pack_end(entry);
window.add(caja);
window.title="first app";
window.show_all();

Gtk.main();
	return 0;
}
