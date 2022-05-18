if ( variable_global_exists( "__imgui_init__" )) {
	var _list	= global.__imgui_init__;
	var _i = 0; repeat( array_length( _list )) {
		menubar.add( _list[ _i ].name, _list[ _i ].func );
		
	}
	global.__imgui_init__ = [];
	
}
