class_name TileMapController extends TileMap


var grid_state = []
var patterns_loaded = false
var cell_pattern_dict = {}


func _enter_tree(): 
	var reader = CellEmenatePatternReader.new()
	# initialize patterns from config files
	for cell_type in Cell.TYPES:
		var value = reader.read_pattern_for_cell_type(cell_type)
		if(value != []):
			cell_pattern_dict[cell_type] = value
	

func _ready():
	var cell_size : Vector2i = self.tile_set.tile_size
	var viewport_size : Vector2i = self.get_viewport_rect().size
	
	var grid_size_x : int = viewport_size.x / cell_size.x
	var grid_size_y : int = viewport_size.y / cell_size.y 
	
	for x in grid_size_x:
		grid_state.append([])
		for y in grid_size_y:
			grid_state[x].append(Vector2i.ZERO)

func _on_virus_antigen_emanate(position : Vector2, type: Cell.TYPES):
	print_debug("Tries handling emanate.")
	
	
	var local_position : Vector2 = to_local(position)
	var map_position : Vector2i = local_to_map(local_position)
	
	print_debug("local coords = x: %d, y: %d" % [local_position.x, local_position.y])
	print_debug("map coords   = x: %d, y: %d" % [map_position.x, map_position.y])
	
	print_debug("Handled emit")
	
func set_pattern_by_cell_type(position: Vector2i, cell_type: Cell.TYPES):
	if(!cell_pattern_dict.has(cell_type)):
		print_debug("Pattern of %s not found." % cell_type)
		return
	var pattern_matrix = cell_pattern_dict[cell_type]
	
	var x_size = pattern_matrix.size
	for x in x_size:
		var y_size = pattern_matrix[x].size
		for y in y_size:
			var next_pos = Vector2i()
			if(is_spot_viable(next_pos)):
				print("")
	print("")

func match_pattern_with_grid_state(pattern_matrix):
	
	return 
	
func is_spot_viable(next_pos: Vector2i) -> bool:
	if(position.x < 0 || position.x > grid_state.size):
		return false
	if(position.y < 0 || position.y > grid_state[0].size):
		return false
	return true

