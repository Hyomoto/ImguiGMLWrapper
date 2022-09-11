function ImguiWindowSettings() constructor {
	static setup	= function() {
		imguigml_set_next_window_size( 384, 0.0 );
		
	}
	static show	= function() {
		var _rem = imguigml_checkbox( "Remove Settings...", remove );
		if ( _rem[ 0 ] ) { remove	= bool( _rem[ 1 ] ); }
		
		var _list	= settings;
		var _o;
		
		var _i = -1; repeat( array_length( _list )) { ++_i;
			if ( imguigml_tree_node( _list[ _i ] )) {
				var _header	= objImgui.settings.data[$ _list[ _i ]];
				var _keys	= variable_struct_get_names( _header );
				var _k	= -1; repeat( array_length( _keys )) { ++_k;
					var _key	= _keys[ _k ];
					var _value	= _header[$ _key ];
					
					if ( remove ) {
						if ( imguigml_button( " X ##" + string( _k )))
							variable_struct_remove( _header, _key );
						imguigml_same_line();
						
					}
					if ( is_bool( _value ))
						_o	= imguigml_checkbox( _key, _value );
					else if ( is_numeric( _value ))
						_o	= imguigml_input_float( _key, _value, 0, 0, 2 );
					else if ( is_string( _value ))
						_o	= imguigml_input_text( _key, _value, 255 );
					else
						_o	= [ false ];
					
					if ( _o[ 0 ] ) {
						objImgui.settings.set( _key + "##" + _list[ _i ], _o[ 1 ] );
						//if ( objImgui.settings.actions[$ _list[ _i ] + "##" + _key ] != undefined )
						//	objImgui.settings.actions[$ _list[ _i ] + "##" + _key ]( _o[ 1 ] );
						//_header[$ _key ]	= _o[ 1 ];
						
					}
					if ( imguigml_is_item_hovered()) {
						var _tooltip	= objImgui.settings.tooltips[$ objImgui.settings.category + "##" + _key ];
						if ( _tooltip != undefined )
							imguigml_set_tooltip( _tooltip );
						
					}
					
				}
				imguigml_tree_pop();
				
			}
			
		}
		
	}
	handle		= "Settings";
	
	settings	= variable_struct_get_names( objImgui.settings.data );
	remove		= false;
	
	array_sort( settings, function( _a, _b ) {
		if ( _a == "Default" )
			return -1;
		if ( _a < _b )
			return -1
		if ( _a == _b )
			return 0;
		return 1;
			
	});
		
}