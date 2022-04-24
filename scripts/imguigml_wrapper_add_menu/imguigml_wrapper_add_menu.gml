/// @param {String}	_name		The name of the menu, this is just an id and will not affect what is shown.
/// @param {Method} _function	A menu constructor.  See Creating a Menu for more information.
/// @desc	Used to attach a menu to the menubar
function imguigml_wrapper_add_menu( _name, _function ) {
	with ( objImguiWrapper ) {
		menubar.add( _name, _function );
		
		return;
		
	}
	if ( variable_global_exists( "__imgui_init__" ) == false )
		global.__imgui_init__	= [];
	array_push( global.__imgui_init__, { name: _name, func: _function });
	
}

