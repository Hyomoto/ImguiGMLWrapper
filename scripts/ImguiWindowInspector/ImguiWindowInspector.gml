function ImguiWindowInspector() constructor {
	static show	= function() {
		static inspector	= imgui.inspector;
		
		if ( instance_exists( inspector.inspecting ) == false )
			return IMGUI_WINDOW_CLOSE;
		
		with( inspector.inspecting ) {
			event_user( IMGUI_INSPECTOR_EVENT );
			imguigml_separator();
				
			var _u = imguigml_input_text( "##watcher", inspector.text, 255 );
			if ( _u[ 0 ] )
				inspector.text	= _u[ 1 ];
				
			imguigml_same_line();
			if ( imguigml_button( "Watch##inspector" )) {
				var _val	= variable_instance_get( id, inspector.text );
				var _inspect= inspector.inspections[$ object_get_name( object_index ) ];
				
				if ( is_undefined( _inspect )) {
					_inspect	= [];
					inspector.inspections[$ object_get_name( object_index ) ]	= _inspect;
						
				}
				
				if ( is_numeric( _val ))
					array_push( _inspect, [ inspector.text, DEV_INSPECT_NUMBER ] );
				else if ( is_string( _val ))
					array_push( _inspect, [ inspector.text, DEV_INSPECT_STRING ] );
				inspector.text	= "";
			
			}
			var _inspect	= inspector.inspections[$ object_get_name( object_index ) ];
			if ( _inspect != undefined ) {
				var _i = 0; repeat( array_length( _inspect )) {
					var _name	= _inspect[ _i ][ 0 ];
					var _value	= variable_instance_get( id, _name );
				
					if ( imguigml_button( " X ##" + string( _i )))
						array_push( inspector.cleanup, _i );
					imguigml_same_line();
				
					if ( _inspect[ _i ][ 1 ] == DEV_INSPECT_NUMBER ) {
						var _u = imguigml_drag_float( "##" + _name, _value, 1, 0, 0 );
						if ( _u[ 0 ] )
							variable_instance_set( id, _inspect[ _i ][ 0 ], _u[ 1 ] );
					
					} else {
						var _u = imguigml_input_text( "##" + _name, _value, 255 );
						if ( _u[ 0 ] )
							variable_instance_set( id, _inspect[ _i ][ 0 ], _u[ 1 ] );
					
					}
					imguigml_same_line();
					imguigml_text( _inspect[ _i++ ][ 0 ] );
				
				}
				if ( array_length( inspector.cleanup )) {
					array_sort( inspector.cleanup, false );
					var _i = 0; repeat( array_length( inspector.cleanup )) {
						array_delete( _inspect, inspector.cleanup[ _i ], 1 );
					
					}
					inspector.cleanup	= [];
				}
			
			}
		
		}
		
	}
	flags	= EImGui_WindowFlags.AlwaysAutoResize;
	
}
