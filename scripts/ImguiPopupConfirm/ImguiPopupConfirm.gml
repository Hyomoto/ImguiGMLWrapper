/// @param {String} _name	The name of the popup. This is the same as what must be called to open it.
/// @param {String} _text	The text to display in the popup.
/// @param {String} _yes	The text to display on the 'Yes' button.  Default: Yes
/// @param {String} _no		The text to display on the 'No' button.  Default: No
/// @param {Boolean} _blocking	If true, an input blocking popup is created.  Default: true
/// @desc Describes a popup with some text and two buttons, by default Yes and No.  If the user
///		clicks 'Yes', true will be returned.  If they click 'No', false is returned.  This will
///		also close the popup. If no input was given, undefined is returned (nothing was clicked).
/// @returns {Real|Undefined}
function ImguiPopupConfirm( _name, _text, _yes = "Yes", _no = "No", _blocking = true ) {
	var _result	= undefined;
	
	imguigml_push_item_width( 512 );
	
	if ( _blocking ? imguigml_begin_popup_modal( _name )[0] : imguigml_begin_popup( _name )) {
		imguigml_text( _text );
		imguigml_separator();
		
		if ( imguigml_button( _yes + "##yes." + _name )) {
			imguigml_close_current_popup();
			_result	= true;
			
		}
		imguigml_same_line();
		if ( imguigml_button( _no + "##no." + _name )) {
			imguigml_close_current_popup();
			_result	= false;
			
		}
		imguigml_end_popup();
		
	}
	return _result;
	
}

