/// @desc Helper Functions
// Inspector Helper
inspector = new ( function() constructor {
	set_default	= function( _index ) {
		var _inspect	= [];
		
		var _i = 1; repeat( argument_count - 1 ) {
			if ( is_real( variable_instance_get( id, argument[ _i ] )))
				array_push( _inspect, [ argument[ _i ], DEV_INSPECT_NUMBER ] );
			else if ( is_string( variable_instance_get( id, argument[ _i ] )))
				array_push( _inspect, [ argument[ _i ], DEV_INSPECT_STRING ] );
			++_i;
		}
		inspections[$ object_get_name( _index ) ]	= _inspect;
		
	}
	inspecting	= noone;
	inspections	= {}
	text		= "";
	cleanup		= [];
	
})();

// Window Helper
window	= new ( function() constructor {
	static open	= function( _name, _script ) {
		table[$ _name ]	= new _script();
		list	= variable_struct_get_names( table );
		
	}
	static close	= function( _name ) {
		array_push( discard, _name )
		
	}
	static invert	= function( _name, _script ) {
		if ( is_open( _name ))
			close( _name );
		else
			open( _name, _script );
		
	}
	static is_open	= function( _name ) {
		return variable_struct_exists( table, _name );
		
	}
	static get_ref	= function( _name ) {
		return table[$ _name ];
		
	}
	static cleanup	= function() {
		if ( array_length( discard ) == 0 )
			return;
		
		var _i = 0; repeat( array_length( discard )) {
			variable_struct_remove( table, discard[ _i++ ] );
			
		}
		list	= variable_struct_get_names( table );
		discard	= [];
		
	}
	list	= [];
	table	= {}
	discard	= [];
	
})();

menubar	= new ( function() constructor {
	static add	= function( _name, _script ) {
		if (( script_exists( _script ) || is_method( _script )) == false )
			return logme( "Error adding menu item %, invalid script/function!", _name );
		array_push( list, [ _name, new _script() ] );
		
		return self;
		
	}
	static remove	= function( _name ) {
		var _i = 0; repeat( array_length( _list )) {
			if ( list[ _i++ ][ 0 ] == _name )
				return array_delete( list, _i - 1, 1 );
			
		}
		
	}
	static shortcut	= function() {
		if ( mask == true )
			return false;
		
		var _result	= false;
		
		switch( argument_count ) {
			default : return false;
			case 1 : _result	= keyboard_check_pressed( argument[ 0 ] ); break;
			case 2 : _result	= keyboard_check( argument[ 0 ] ) && keyboard_check_pressed( argument[ 1 ] ); break;
			case 3 : _result	= keyboard_check( argument[ 0 ] ) && keyboard_check( argument[ 1 ] ) && keyboard_check_pressed( argument[ 2 ] ); break;
			
		}
		if ( _result )
			mask	= true
		return _result;
		
	}
	mask	= false;
	list	= [];
	show	= imgui.settings.read( "Show Menubar", true, "Whether or not the menu bar is shown." );
	imgui.settings.on_change( "Show Menubar", function( _v ) {
		show	= _v;
		
	});
	
})();

mouse	= new ( function() constructor {
	static update	= function() {
		if ( mouse_check_button_pressed( mb_left ) && imgui.WantCaptureMouse == false )
			left	= IMGUI_MOUSE_PRESSED;
		else
			left	= IMGUI_MOUSE_FREE;
		
		if ( mouse_check_button_pressed( mb_right ) && imgui.WantCaptureMouse == false )
			right	= IMGUI_MOUSE_PRESSED;
		else
			right	= IMGUI_MOUSE_FREE;
		
	}
	left	= 0;
	right	= 0;
	
})();

search	= new( function() constructor {
	/// @param array	The array to filter
	/// @param [kwargs]
	/// @desc kwargs are
	///		key: a unique search key, used to create multiple filters
	///		compare: a function in the form function( _input, _compare ), and returns true if they match
	///		modify: a function that modifies the input text, default: string_lower
	static filter	= function( _array, _kwargs = {}) {
		var _id	= _kwargs[$ "key" ] ?? "default";
		
		if ( searches[$ _id ] == undefined )
			searches[$ _id ] = { list: _array, text: "" }
		
		var _search	= searches[$ _id ];
		
		imguigml_text( "Search " );
		imguigml_same_line();
		
		var _input	= imguigml_input_text( "##Search", _search.text, 255 );
		imguigml_same_line();
		
		if ( imguigml_button( "Reset" ) || ( _input[ 0 ] && _input[ 1 ] == "" )) {
			_search.list	= _array;
			_search.text	= "";
			
		} else {
			if ( _input[ 0 ] && string_lower( _input[ 1 ] ) != _search.text && _input[ 1 ] != "" ) {
				var _compare	= _kwargs[$ "compare" ] ?? function( _text, _compare ) { return string_pos( _text, _compare ) > 0 };
				var _modify		= _kwargs[$ "modify" ] ?? string_lower;
				
				_search.list	= [];
				_search.text	= _modify( _input[ 1 ] );
				
				var _i = 0; repeat( array_length( _array )) {
					if ( _compare( _search.text, _modify( _array[@ _i++ ] )))
						array_push( _search.list, _array[@ _i - 1 ] )
				}
				
			}
			
		}
		imguigml_separator();
	
		return _search.list;
	
	}
	static reset	= function( _key = "default" ) {
		variable_struct_remove( searches, _key );
		
	}
	searches	= {}
	text		= "";
	list		= [];
	last		= undefined;
	
})();

close_inspector	= function() {
	inspectText	= "";
	inspecting	= noone;
	
}
