function item_add(_item){
	var _added = false;
	
	if array_length( obj_player_data.inv ) < obj_player_data.inv_max
	{
		array_push( obj_player_data.inv, _item );
		_added = true;
	}
	
	return _added;
}