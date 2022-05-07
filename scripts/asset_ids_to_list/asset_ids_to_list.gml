/// @param _array
/// @param _func
function asset_ids_to_list( _array, _func ) {
	var _output	= array_create( array_length( _array ));
	
	var _i = -1; repeat( array_length( _output )) { ++_i;
		_output[ _i ]	= _func( _array[ _i ] );
		
	}
	return _output;
	
}
