function imguigml_wrapper_mouse( _button = mb_left, _action = mouse_check_button_pressed ) {
	with( imgui ) {
		if WantCaptureMouse
			return false;
	}
	return _action( _button );
	
}


