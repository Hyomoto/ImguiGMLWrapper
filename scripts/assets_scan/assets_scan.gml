/// @param _exists	The function to use to check if the asset exists
/// @param _filter	A function that, if true, omits this entry from the list.
function assets_scan( _exists, _filter = function( _a ) { return false; }) {
	var _list	= [];
	
	var _i = 0; while( _exists( _i )) {
		if ( _filter( _i++ ) == false )
			array_push( _list, _i - 1 );
			
	}
	return _list;
	
}
