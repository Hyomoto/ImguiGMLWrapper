#macro imgui_wrapper	__imgui_wrapper()
function __imgui_wrapper() {
	// feather ignore once GM1021
	static instance	= new ( function() constructor {
		// feather ignore once GM1043
		// feather ignore once GM1021
		settings	= new ( function() constructor {
			static set_category	= function( _category ) {
				category	= _category;
				
				if ( not variable_struct_exists( data, _category ))
					data[$ _category ]	= {}
				
				cache	= data[$ _category ];
				
			}
			static set_category_from_key	= function( _key ) {
				var _category	= "Default";
				var _name		= _key;
		
				if ( string_pos( "##", _name ) > 0 ) {
					var _snip	= string_pos( "##", _key );
			
					_category	= string_delete( _key, 1, _snip + 1 );
					_name		= string_copy( _key, 1, _snip - 1 );
			
				}
				if ( _category == "" )
					return imgui_wrapper.logme( "objImguiWrapper :: Couldn't read %, category must be named or omitted!", _key, _category );
				if ( _name == "" )
					return imgui_wrapper.logme( "objImguiWrapper :: Couldn't resolve %, variable must be named.", _key, _name );
				
				set_category( _category );
				
				return _name;
				
			}
			static read	= function( _name, _default, _tooltip ) {
				var _key	= set_category_from_key( _name );
				if ( _key == undefined )
					return;
		
				if ( not variable_struct_exists( cache, _key ))
					cache[$  _key ] = _default;
		
				if ( _tooltip != undefined )
					tooltips[$ category + "##" + _key ] = _tooltip;
		
				if ( is_bool( _default ))
					cache[$ _key ] = bool( cache[$ _key ] );
		
				return cache[$ _key ];
		
			}
			static on_change= function( _name, _f ) {
				var _key	= set_category_from_key( _name );
				if ( _key == undefined )
					return;
			
				if ( variable_struct_exists( cache, _key ) == false )
					return;
		
				actions[$ _key + "##" + category ]	= _f;
		
			}
			static set		= function( _name, _value ) {
				var _key	= set_category_from_key( _name );
				if ( _key == undefined )
					return;
				
				cache[$ _key ] = _value;
				
				if ( actions[$ _key + "##" + category ] )
					actions[$ _key + "##" + category ]( _value );
				
				return _value;
				
			}
			static save	= function( _filename ) {
				var _file	= file_text_open_write( _filename );
				
				file_text_write_string( _file, json_stringify( data ));
				
				file_text_close( _file );
				
			}
			static load	= function( _filename ) {
				var _file	= file_text_open_read( _filename );
				if ( _file == -1 ) {
					error	= 1; // file not found
					return;
				}
				data	= json_parse( file_text_read_string( _file ));
				
				file_text_close( _file );
				
				error	= 0; // no error
				
			}
			category	= "Default";
			data		= {};
			cache		= undefined;
			tooltips	= {};
			actions		= {};
			error		= undefined;
			
			// initialize settings
			load( IMGUI_SETTINGS_FILENAME );
			set_category( "Default" );
			
		})();
		/// @desc Helper Functions
		// Inspector Helper
		// feather ignore once GM1043
		// feather ignore once GM1021
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
			override	= function( _script = ImguiWindowInspector ) {
				if ( is_method( _script ) == false && script_exists( _script ) == false )
					return imgui_wrapper.logme(  "objImguiWrapper :: Bad value passed as inspector override: '%'!", _script );
				script	= _script;
				
			}
			inspecting	= noone;
			inspections	= {}
			script		= ImguiWindowInspector;
			text		= "";
			cleanup		= [];
	
		})();

		// Window Helper
		// feather ignore once GM1043
		// feather ignore once GM1021
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

		// feather ignore once GM1043
		// feather ignore once GM1021
		menubar	= new ( function() constructor {
			static add	= function( _name, _script ) {
				if (( script_exists( _script ) || is_method( _script )) == false )
					return imgui_wrapper.logme( "Error adding menu item %, invalid script/function!", _name );
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
			static get_ref	= function( _name ) {
				return table[$ _name ];
				
			}
			show	= true;
			mask	= false;
			list	= [];
			
		})();

		// feather ignore once GM1043
		// feather ignore once GM1021
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

		// feather ignore once GM1043
		// feather ignore once GM1021
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
		
		logme	= function( _args ) {
			if ( is_array( argument[ 0 ] ) == false ) {
				var _a	= array_create( argument_count );
				var _i = 0; repeat( argument_count ) { _a[ _i ] = argument[ _i ]; ++_i; }
				_args	= _a;
				
			}
			var _string = _args[ 0 ], _i = 0, _a = 1; repeat( string_count( "%", _string )) {
				if ( _a >= array_length( _args ))
					break;
				
				var _n	= string_pos_ext( "%", _string, _i );
				
				if ( _n != 1 && string_char_at( _string, _n - 1 ) == "\\" ) {
					_string	= string_delete( _string, _n - 1, 1 );
					_i		= _n - 1;
					
				} else {
					if ( string_char_at( _string, _n + 1 ) == "[" ) {
						var _s		= string_pos_ext( "]", _string, _n + 1 );
						var _sep	= string_copy( _string, _n + 2, _s - _n - 2 );
						
						_string	= string_delete( _string, _n + 1, _s - _n );
						
						if ( is_array( _args[ _a ] )) {
							var _array	= _args[ _a++ ];
							var _as		= "";
							
							var _v = 0; repeat( array_length( _array )) {
								if ( _v > 0 )
									_as	+= _sep;
								_as	+= string( _array[ _v++ ] );
								
							}
							_string	= string_copy( _string, 1, _n - 1 ) + string( _as ) + string_delete( _string, 1, _n );
							_i		= _n - 1 + string_length( _as );
							
							continue;
							
						}
						
					}
					_string	= string_copy( _string, 1, _n - 1 ) + string( _args[ _a ] ) + string_delete( _string, 1, _n );
					_i		= _n - 1 + string_length( string( _args[ _a++ ] ));
					
				}
				
			}
			show_debug_message( _string );
			
		}
		close_inspector	= function() {
			inspectText	= "";
			inspecting	= noone;
	
		}
		menubar.show = bool( settings.read( "Show Menubar", true, "Whether or not the menu bar is shown." ));
		settings.on_change( "Show Menubar", function( _v ) {
			menubar.show	= _v;
			
		});
		menubar.add( "File", ImguiFileMenu );
		settings.read( "Inspector Enable", true, "Enables the inspector window." );
		
		initialized	= false;
		
	})();
	
	return instance;
	
}
