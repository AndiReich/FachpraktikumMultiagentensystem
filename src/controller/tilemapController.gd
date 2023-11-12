class_name TileMapController extends TileMap


var grid_state = []

func _ready():
	var cell_size = self.tile_set.tile_size
	var viewport_size = self.get_viewport_rect().size
	
	var grid_size_x = viewport_size.x / cell_size.x
	var grid_size_y = viewport_size.y / cell_size.y 
	
	for x in grid_size_x:
		grid_state.append([])
		for y in grid_size_y:
			grid_state[x].append(Vector2i.ZERO)

func _on_virus_antigen_emanate(position : Vector2, type: Cell.TYPES):
	# maybe send over a TileMapPattern
	print("Tries handling emanate")	
	var local_position = to_local(position)
	var map_position = local_to_map(local_position)
	
	
	print("local coords = x: %d, y: %d" % [local_position.x, local_position.y])
	print("map coords   = x: %d, y: %d" % [map_position.x, map_position.y])
	set_cell(0, Vector2i(map_position.x,map_position.y), 0, Vector2i(3,0))
	print("Handled emit")
	force_update(0)

func preCheckPatternAgainstGrid():
	print("test")
	
func setPatternForCell():
	print("test")
