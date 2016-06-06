using Gtk;
using BabeList;
namespace BabePlayList
{	
const string playlist_path="./Playlist/";
public class BPlayList : Gtk.ScrolledWindow
{
	public string name;
	private Gtk.ListStore main_list;
	private Gtk.CellRendererText main_list_cell;
	private Gtk.TreeView main_list_view;
	public Gtk.TreeIter iter;
	public Gtk.Revealer reveal1;
	public Gtk.Revealer reveal2;
	public Gtk.EventBox event;
	public Gtk.Label title;
	public Gtk.Box box;
	public Gtk.Box box2;
	public Gtk.Stack stack;
	private Gtk.TreeView treeview;
	private Gtk.ListStore liststore;
	private Gtk.Revealer reveal;

	//public BList playlist;
	public int c=0;
	public BPlayList()//whether the list has to be populate from start//useful for saved playlists(true=populate/false=start empty, the path to the playlist)
	{					
		Object(hadjustment: null, vadjustment: null);

		this.set_min_content_height(200);
		this.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		treeview=new Gtk.TreeView();
		//liststore=new Gtk.ListStore();
		main_list = new Gtk.ListStore (5, typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));
		main_list_cell = new Gtk.CellRendererText ();
		main_list_view= new Gtk.TreeView.with_model (main_list);

		main_list_view.insert_column_with_attributes (-1, "Title", main_list_cell, "text", 0);			
		main_list_view.set_grid_lines (TreeViewGridLines.BOTH);
		main_list_view.set_reorderable(true);
		main_list_view.set_headers_visible(false);
		main_list_view.set_enable_search(true);	
		
		main_list_view.row_activated.connect(this.on_row_activated);
		
		
		var icon = new Gtk.Image.from_icon_name("pan-end-symbolic-rtl", Gtk.IconSize.MENU);
		var event = new Gtk.EventBox();
		event.add(icon);
		icon.set_tooltip_text ("Open...");
		
		title= new Gtk.Label("");
		stack=new Gtk.Stack();
		stack.set_vexpand(true);//main list			
		set_playlists();
		stack.add_named(main_list_view, "list");
		stack.set_visible_child_name("list");
			
		event.button_press_event.connect (() => {
			stack.set_visible_child_name("list");
			reveal.set_reveal_child(false);

					return true;
		});
		reveal=new Gtk.Revealer();
		reveal.set_transition_type(RevealerTransitionType.SLIDE_UP);

		var box=new Gtk.Box(Gtk.Orientation.VERTICAL,0);
		var title_box= new Gtk.Box(Gtk.Orientation.HORIZONTAL,0);
		title_box.add(event);
		title_box.add(title);		
		reveal.add(title_box);
		reveal.set_reveal_child(false);
		box.add(reveal);
		box.add(stack);		
		this.add(box);
	}
	

	
	private void on_row_activated (Gtk.TreePath path, Gtk.TreeViewColumn column) //double click starts playback
	{
		c++;
		
		string list_path="";
		var model=main_list_view.get_model();

        if (main_list_view.model.get_iter (out iter, path)) {
		model.get (iter,
                        0, out list_path);

        }      
		
			/*playlist.clean_list();
			playlist.populate_playlist(list_path);*/
			title.label=list_path;
       		stack.set_visible_child_name(list_path);       		
       		reveal.set_reveal_child(true);			
			name=stack.get_visible_child_name();
			//print(name);
	}	
	
	public void show_main_list()
	{
		stack.set_visible_child_name("list");
	}
		
	public void set_playlists()
	{		
		var directory = GLib.File.new_for_path (playlist_path);
		 
		if (!(directory.query_exists()))
		{
           		try
           		{
					directory.make_directory();
				}catch(GLib.Error e)
				{
					print("clound't create Playlist dir");
				}	
        }
        try 
		{					
			var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) 
			{        
				GLib.File path = enumerator.get_child (file_info);
				if( file_info.get_name ().has_suffix(".babe"))
				{
					main_list.append (out iter);
					main_list.set (iter, 0, file_info.get_name ().replace(".babe",""), 1,"./Playlist/"+file_info.get_name ());
					var playlist=new BList(true,"./Playlist/"+file_info.get_name ());
					
					stack.add_named(playlist, file_info.get_name ().replace(".babe",""));	
					stack.set_vexpand(true);				
							
				}
				
				
					
			}

		} catch (GLib.Error e)
		{
			stderr.printf ("Error: %s\n", e.message);
      
		} 			
	}
	
	
		
	public void add_playlist(string playlist_name)
	{
			//stdout.printf ("%s\n", str);
			//system("mkdir playlists");
			var file = GLib.File.new_for_path (playlist_path+playlist_name+".babe");
			
			if (!(file.query_exists()))
			{
				file.create (FileCreateFlags.NONE);
			}else
			{
				print("already exists");
			}
			
		main_list.append (out iter);
		main_list.set (iter, 0, playlist_name);	
	}
		
	public Gtk.TreeView get_treeview()
	{
		var pl=get_BList();
		var treeview=pl.get_treeview();
		return treeview;
		
	}	
	
	public Gtk.ListStore get_liststore()
	{			
		return liststore;
	}
		
	public BList get_BList()
	
	{
		string nm= "hola";
		print(nm+" @@@ "+name);
		BList list = (BList) stack.get_child_by_name(name);
		return  list;
	}
}
}
/*
static int main(string[] args)
{
	Gtk.init(ref args);
	var empty_list=new BPlayList();
		var window=new Gtk.Window();
	var box=new Gtk.Box(Gtk.Orientation.VERTICAL,0);
	empty_list.set_playlists();
	box.add(empty_list);
	window.add(box);
	window.show_all();
	Gtk.main();
	return 0;
}
*/


