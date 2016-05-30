using Gtk;
using TagLib;
using BabeList;

namespace BabeList
{
	public class BList : Gtk.ScrolledWindow
	{
		private Gtk.ListStore main_list;
		private Gtk.CellRendererText main_list_cell;
		private Gtk.TreeView main_list_view;
		public Gtk.TreeIter iter;
	
		public BList()
		{						
			Object(hadjustment: null, vadjustment: null);
			main_list = new Gtk.ListStore (5, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
			main_list_cell = new Gtk.CellRendererText ();
			main_list_view= new Gtk.TreeView.with_model (main_list);

			main_list_view.insert_column_with_attributes (-1, "Title", main_list_cell, "text", 0);
			
			this.set_min_content_height(200);
			this.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
			this.add (main_list_view);
		}
		
		public void populate(string uri)
		{
					
			var file = GLib.File.new_for_uri (uri);

if (file.query_exists() )
		{
			main_list.append (out iter);
			main_list.set (iter, 0, get_song_info(uri).tag.title+"\nby "+ get_song_info(uri).tag.artist, 1, get_song_info(uri).tag.artist, 2, uri, 3,get_song_info(uri).tag.album,4,get_song_info(uri).tag.title);
           print(" existe");
        }else
        {print(" no existe");
			
		}
			
			
		
			
		}
		
		public TagLib.File get_song_info(string uri)//it actually turn a uri into a path to be able to get the tags
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
	}
	
	
	
}


public static int main(string[] args)
{
Gtk.init(ref args);
var window = new Gtk.Window();
BList as= new BList();

//as.get_treeview().set_grid_lines (TreeViewGridLines.BOTH);
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
