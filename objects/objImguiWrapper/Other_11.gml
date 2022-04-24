/// @desc Settings Helper
settings	= new ( function() constructor {
	static set_category	= function( _category ) {
		category	= _category;
		
		if ( not variable_struct_exists( data, _category ))
			data[$ _category ]	= {}
		
		cache	= data[$ _category ];
		
	}
	static set_category_from_key	= function( _key ) {
		var _category	= "Default";
		var _name		= _key;
		
		if ( string_pos( "##", _name ) > 0 ) {
			var _snip	= string_pos( "##", _key );
			
			_category	= string_delete( _key, 1, _snip + 1 );
			_name		= string_copy( _key, 1, _snip - 1 );
			
		}
		if ( _category == "" )
			return logme( "objImguiWrapper :: Couldn't read %, category must be named or omitted!", _key, _category );
		if ( _name == "" )
			return logme( "objImguiWrapper :: Couldn't resolve %, variable must be named.", _key, _name );
		
		set_category( _category );
		
		return _name;
		
	}
	static read	= function( _name, _default, _tooltip ) {
		var _key	= set_category_from_key( _name );
		if ( _key == undefined )
			return;
		
		if ( not variable_struct_exists( cache, _key ))
			cache[$  _key ] = _default;
		
		if ( _tooltip != undefined )
			tooltips[$ category + "##" + _key ] = _tooltip;
		
		if ( is_bool( _default ))
			cache[$ _key ] = bool( cache[$ _key ] );
		
		return cache[$ _key ];
		
	}
	static on_change= function( _name, _f ) {
		var _key	= set_category_from_key( _name );
		if ( _key == undefined )
			return;
			
		if ( variable_struct_exists( cache, _key ) == false )
			return;
		
		actions[$ _key + "##" + category ]	= _f;
		
	}
	static set		= function( _name, _value ) {
		var _key	= set_category_from_key( _name );
		if ( _key == undefined )
			return;
		
		cache[$ _key ] = _value;
		
		if ( actions[$ _key + "##" + category ] )
			actions[$ _key + "##" + category ]( _value );
		
		return _value;
		
	}
	category	= "Default";
	data		= {};
	cache		= undefined;
	tooltips	= {};
	actions		= {};
	
})();