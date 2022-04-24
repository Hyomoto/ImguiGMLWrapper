#macro IMGUI_SETTINGS_FILENAME	"imgui_settings.cfg"

// Inherit the parent event
event_inherited();

// load helper functions
event_user( 1 ); // settings

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

save_settings	= function( _filename ) {
	var _file	= file_text_open_write( _filename );
	
	file_text_write_string( _file, json_stringify( settings.data ));
	
	file_text_close( _file );
	
}
load_settings	= function( _filename ) {
	var _file	= file_text_open_read( _filename );
	if ( _file == -1 )
		return logme( "objImguiWrapper :: Couldn't load % because it didn't exist!", _filename );
	
	settings.data	= json_parse( file_text_read_string( _file ));
	
	logme( "objImguiWrapper :: Settings loaded from %.", _filename );
	
	file_text_close( _file );
	
}
// initialize settings
load_settings( IMGUI_SETTINGS_FILENAME );
settings.set_category( "Default" );
values	= {};

event_user( 0 ); // windows

version	= ( function() {
	if (!__imguigml_ext_call(_extImguiGML_get_version()))
		return;
	return buffer_read(__Imgui_out, buffer_string);
	
})();

// initial built-in features
menubar.add( "File", ImguiFileMenu );
settings.read( "Inspector Enable", true, "Enables the inspector window." );
var _scale	= settings.read( "Imgui Scale", 1, "Allows you to change what scale Imgui is rendered at." );
settings.on_change( "Imgui Scale", function( _v ) {
	imguigml_set_display_scale( _v, _v );
	
});

imguigml_set_display_scale( _scale, _scale );

logme( "objImguiWrapper :: Initialized.  Imgui % in use.", version );

#macro IMGUI_INSPECTOR_EVENT	0

#macro DEV_INSPECT_NUMBER	0
#macro DEV_INSPECT_STRING	1

#macro IMGUI_RUN			0
#macro IMGUI_START			1
#macro IMGUI_INITIALIZE		2

#macro IMGUI_WINDOW_CLOSE	1

#macro IMGUI_MOUSE_FREE		0
#macro IMGUI_MOUSE_PRESSED	1
#macro IMGUI_MOUSE_HELD		2
#macro IMGUI_MOUSE_RELEASED	3
