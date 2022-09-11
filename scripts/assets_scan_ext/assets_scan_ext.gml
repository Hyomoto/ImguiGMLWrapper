/// @param _exists		The function to use to check if the asset exists
/// @param _startAt	The index to start at, default is 0.
/// @param _sort		Whether or not to sort the list after generation.
/// @param {Function} _sub		A function that returns the value to be used.
/// @param {Function} _filter	A function that, if true, omits this entry from the list.
function assets_scan_ext( _exists, _startAt, _sort, _sub = function( _a ) { return _a; }, _filter = function( _a ) { return false; }) {
	var _list	= [];
	
	var _i = _startAt; while( _exists( _i )) {
		if ( _filter( _i++ ) == false )
			array_push( _list, _sub( _i - 1 ));
		
	}
	if ( _sort != 0 )
		array_sort( _list, _sort > 0 ? true : false );
	return _list;
	
}

