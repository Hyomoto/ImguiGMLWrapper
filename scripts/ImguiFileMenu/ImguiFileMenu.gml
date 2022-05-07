function ImguiFileMenu( _mode, _show ) constructor {
	static show	= function() {
		if ( imguigml_begin_menu( "Restart..." )) {
			if ( imguigml_menu_item( "Room", "Ctrl+R" ))
				room_restart();
			else if ( imguigml_menu_item( "Game", "Ctrl+Shift+R" ))
				game_restart();
			imguigml_end_menu();
				
		}
		if ( imguigml_begin_menu( "Goto..." )) {
			var _list	= imgui.search.filter( __roomList__ );
				
			var _i = 0; repeat( array_length( _list )) {
				if ( imguigml_menu_item( _list[ _i++ ] ))
					room_goto( __roomIds__[$ _list[ _i - 1 ]] );
					
			}
			imguigml_end_menu();
				
		}
		imguigml_separator();
			
		if ( imguigml_menu_item( "Settings", "Ctrl+Shift+S" )) {
			if ( not imgui.window.is_open( "File>Settings" ))
				imgui.window.open( "File>Settings", ImguiWindowSettings );
				
		}
		if ( imguigml_menu_item( "Quit", "Ctrl+Q" )) {
			game_end();
				
		}
			
	}
	static step	= function() {
		var _menubar	= imgui.menubar;
		
		if ( _menubar.shortcut( vk_control, vk_shift, ord( "R" )) )
			game_restart();
		if ( _menubar.shortcut( vk_control, ord( "R" )) )
			room_restart();
		if ( _menubar.shortcut( vk_control, vk_shift, ord( "S" )) )
			imgui.window.open( "File>Settings", ImguiWindowSettings );
		if ( _menubar.shortcut( vk_control, ord( "Q" )) )
			game_end();
		
	}
	__roomList__	= assets_scan_ext( room_exists, 0, 1, room_get_name );
	__roomIds__		= asset_ids_to_struct( __roomList__ );
	
}

