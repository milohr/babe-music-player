using Gtk;
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
		
		public void populate()
		{
			main_list.append (out iter);
			main_list.set (iter, 0, "camilo", 1, "higuita", 2, "rodriguez", 3,"rivera",4,"restrepo");
			
		}
		
				
	}
	
	
	
}


public static int main(string[] args)
{
Gtk.init(ref args);
var window = new Gtk.Window();
BList as= new BList();
as.populate();
as.show_all();
var caja = new Gtk.Box(Gtk.Orientation.VERTICAL,0);
caja.add(as);
window.add(caja);
window.title="first app";
window.show_all();

Gtk.main();
	return 0;
}
