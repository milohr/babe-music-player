//file taken from: https://github.com/xyl0n/tempo-player/blob/master/src/Core/lastfm.vala

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

namespace CoverArt{
public class LastFm {

    private const string API = "ba6f0bd3c887da9101c10a50cf2af133";

    public string? image_uri = null;

    public Gdk.Pixbuf? download_cover_art (string url) {//string url, string dest)

        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);

        session.send_message (message);
        if (message==null)
        {
			print("hubo un error en soup");
			return null;
		}else
		{

        Gdk.PixbufLoader loader = new Gdk.PixbufLoader ();
        loader.write (message.response_body.data);

        Gdk.Pixbuf image = loader.get_pixbuf ();
        string name = generate_image_key (url);
        //print("--<<<<<< "+name);
       // image.save (name, "png");
        loader.close ();
        return image;
		}

    }

    public string generate_image_key (string text) {
        return GLib.Checksum.compute_for_string(ChecksumType.MD5, text, text.length);
    }

    public string? get_art_uri (string album, string artist) {
        var url = "http://ws.audioscrobbler.com/2.0/?api_key="+ API +
                  "&method=album.getinfo&artist=" + artist + "&album=" + album;

        Xml.Doc* doc = Xml.Parser.parse_file (url);
        doc->save_file ("test2");
        if (doc == null) {
            stderr.printf ("LastFM Album info not found\n");
            return null;
        }

        Xml.Node* root = doc->get_root_element ();
        if (root == null) {
            delete doc;
            stderr.printf ("Could not find any elements for album %s\n", album);
            return null;
        }

        parse_node (root, "");

        delete doc;

        return this.image_uri;
    }

     public string? get_artist_uri (string artist) {
        var url = "http://ws.audioscrobbler.com/2.0/?api_key="+ API +
                  "&method=artist.getinfo&artist=" + artist;

        Xml.Doc* doc = Xml.Parser.parse_file (url);
        doc->save_file ("test2");
        if (doc == null) {
            stderr.printf ("LastFM Album info not found\n");
            return null;
        }

        Xml.Node* root = doc->get_root_element ();
        if (root == null) {
            delete doc;
            stderr.printf ("Could not find any elements for album %s\n", artist);
            return null;
        }

        parse_node (root, "");

        delete doc;

        return this.image_uri;
    }

    // Sorry for stealing your code elementary :P

    private void parse_node (Xml.Node* node, string parent) {

        // Loop over the passed node's children
        for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {

            // Spaces between tags are also nodes, discard them
            if (iter->type != Xml.ElementType.ELEMENT_NODE) {
                continue;
            }

            string node_name = iter->name;
            string node_content = iter->get_content ();

            if(parent == "album") {
                if(node_name == "image") {
                    if(iter->get_prop("size") == "large") {
                        image_uri = node_content;
                    }
                }
            }

            // Followed by its children nodes
            parse_node (iter, parent + node_name);
        }
    }
}
}
