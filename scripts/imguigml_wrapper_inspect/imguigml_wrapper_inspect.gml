/// @param	{Id.Instance}	_id	The instance to ispect
/// @desc	Opens up the imgui inspector if it's closed, and assigns it to the specified
///		instance.
function imguigml_wrapper_inspect( _id ) {
	if ( ( is_numeric( _id ) && instance_exists( _id )) == false ) {
		imgui.logme( "Bad reference, % couldn't be inspected.", _id );
		return;
		
	}
	with( objImguiWrapper ) {
		if ( settings.data[$ "Default" ][$ "Inspector Enable" ] == false )
			return;
		
		if ( not window.is_open( "Inspector" ))
			window.open( "Inspector", inspector.script );
		window.get_ref( "Inspector" ).handle = "Inspector :: " + object_get_name( _id.object_index );
		
		if ( inspector.inspecting != _id )
			inspector.inspecting	= _id;
			
	}
	
}

