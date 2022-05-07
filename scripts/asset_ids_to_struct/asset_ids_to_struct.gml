/// @param {Array}		_array	The array of assets to check.
/// @param {Function}	_func	The function to check for asset validity. Default: asset_get_index
function asset_ids_to_struct( _array, _func = asset_get_index ) {
	var _output	= {};
	
	var _i = -1; repeat( array_length( _array )) { ++_i;
		_output[$ _array[ _i ]] = _func( _array[ _i ]);
		
	}
	return _output;
	
}
