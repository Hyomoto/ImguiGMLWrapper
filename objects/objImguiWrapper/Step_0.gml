// Inherit the parent event
event_inherited();

// # Pointer Update
mouse.update();

// unmask shortcuts
menubar.mask	= false;

// # Menu Bar Update
if ( menubar.show ) {
	imguigml_begin_main_menu_bar();
	
	var _i = 0; repeat( array_length( menubar.list )) {
		var _info	= menubar.list[ _i++ ];
		var _menu	= _info[ 1 ];
		var _name	= ( _menu[$ "handle" ] ?? _info[ 0 ] ) + "##menu" + string( _i );
		var _enable	= _menu[$ "enable" ] ?? true;
		
		if ( imguigml_begin_menu( _name, _enable )) {
			_menu.show();
			
			imguigml_end_menu();
			
		}
		_menu.step();
		
	}
	var _w	= imguigml_get_content_region_avail_width() / imguiScale;
	imguigml_same_line( _w ); imguigml_text( "FPS:" + string( fps ));
	
	imguigml_end_main_menu_bar();
	
} else {
	var _i = 0; repeat( array_length( menubar.list )) {
		var _menu	= menubar.list[ _i++ ][ 1 ];
		
		_menu.step();
		
	}
	
}
// # Window update
var _i = 0; repeat( array_length( window.list )) {
	var _name	= window.list[ _i++ ];
	var _window	= window.table[$ _name ];
	var _setup	= _window[$ "setup" ];
	
	if ( _setup != undefined )
		_setup();
		
	var _open	= imguigml_begin(( _window[$ "handle" ] ?? "Imgui" ) + "##window",
							 _window[$ "open" ] ?? true,
							 _window[$ "flags"] ?? 0 );
	
	var _close	= (_window.show() == IMGUI_WINDOW_CLOSE ) || _open[ 1 ] == 0;
	if ( _close )
		window.close( _name );
	else
		imguigml_end();
	
}
window.cleanup();

