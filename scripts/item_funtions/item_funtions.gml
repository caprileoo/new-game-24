function item_add(_item){
	var _added = false;

	for (var _i = 0; _i < array_length( obj_player_data.inv ); _i++) {
	    if (obj_player_data.inv[_i].item_name == _item.item_name) {
	        // Stack existing item
	        obj_player_data.inv[_i].quantity += 1;
			_added = true;
			return _added;
	    }
	}
	if array_length( obj_player_data.inv ) < obj_player_data.inv_max
	{
		_item.quantity = 1;
		array_push( obj_player_data.inv, _item );
		_added = true;
	}
	
	return _added;
}