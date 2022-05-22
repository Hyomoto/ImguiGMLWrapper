#macro IMGUI_SETTINGS_FILENAME	"imgui_settings.cfg"

// Inherit the parent event
event_inherited();

// link sources
settings	= __imgui_wrapper().settings;
menubar		= __imgui_wrapper().menubar;
window		= __imgui_wrapper().window;
inspector	= __imgui_wrapper().inspector;
mouse		= __imgui_wrapper().mouse;
search		= __imgui_wrapper().search;
logme		= __imgui_wrapper().logme;

values	= {};

// feather ignore once GM1043
version	= ( function() {
	if (!__imguigml_ext_call(_extImguiGML_get_version()))
		return;
	return buffer_read(__Imgui_out, buffer_string);
	
})();

if ( settings.error == 1 )
	logme( "objImguiWrapper :: Couldn't load % because it didn't exist!", IMGUI_SETTINGS_FILENAME );
else
	logme( "objImguiWrapper :: Settings loaded from %.", IMGUI_SETTINGS_FILENAME );
	
// initial built-in features
imguiScale	= settings.read( "Imgui Scale", 1, "Allows you to change what scale Imgui is rendered at." );
settings.on_change( "Imgui Scale", function( _v ) {
	imguigml_set_display_scale( _v, _v );
	imguiScale	= _v;
	
});

imguigml_set_display_scale( imguiScale, imguiScale );
// feather ignore once GM1019
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
