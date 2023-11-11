class_name TileMapController extends TileMap


func _on_antigen_emanate(pos_x, pos_y, value):
	print("Tries handling emanate")	
	var local_position = to_local(Vector2(pos_x, pos_y))
	var map_position = local_to_map(local_position)
	print("local coords = x: %d, y: %d" % [pos_x, pos_y])
	print("map coords   = x: %d, y: %d" % [map_position.x, map_position.y])
	set_cell(0,map_position,1,Vector2i(0,value-1))
	print("Handled emit")
