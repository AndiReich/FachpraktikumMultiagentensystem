class_name TileMapController extends TileMap


var grid_state = [] # type hints for nested collections are not supported yet...
var patterns_loaded: bool = false
var cell_pattern_dict: Dictionary = {}
var grid_size_x: int
var grid_size_y: int


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

	grid_size_x = viewport_size.x / cell_size.x
	grid_size_y = viewport_size.y / cell_size.y 
	
	for x in grid_size_x:
		grid_state.append([])
		for y in grid_size_y:
			grid_state[x].append(0.0)

func _on_virus_antigen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position : Vector2i = self.local_to_map(cell_position)
	set_pattern_by_cell_type(map_position, type_id)
	
func set_pattern_by_cell_type(cell_position: Vector2i, type_id: Cell.TYPES):
	var cell_type = Cell.TYPES.find_key(type_id)
	if(!cell_pattern_dict.has(cell_type)):
		print_debug("Pattern of %s not found." % cell_type)
		return
	var pattern_matrix = cell_pattern_dict[cell_type]
	var matrix_x_size = pattern_matrix.size()
	var matrix_y_size = pattern_matrix[0].size()
	var offset_x = cell_position.x - (matrix_x_size/2) 
	var offset_y = cell_position.y - (matrix_y_size/2)
	
	for local_x in pattern_matrix.size():
		var global_x = offset_x + local_x
		for local_y in pattern_matrix[0].size():
			var global_y = offset_y + local_y
			var value = int(pattern_matrix[local_x][local_y])
			if(is_position_valid(global_x, global_y, value)):
				grid_state[global_x][global_y] += value

# not that it matters, but we could check for valid positions in each loop to 
# avoid three if statements per x,y iteration in set_patter_by_cell_type
func is_position_valid(x: int, y: int, value: float) -> bool:
	if(x < 0 || x >= grid_state.size()):
		return false
	if(y < 0 || y >= grid_state[0].size()):
		return false
	if(grid_state[x][y] >= value):
		return false
	return true

