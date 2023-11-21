class_name TileMapController extends TileMap

enum SUBSTANCE_TYPE {IL2, IL4, IL5, IL6, CHEMO}

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
			grid_state[x].append(0)

func _on_virus_antigen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position : Vector2i = self.local_to_map(cell_position)
	set_pattern_by_cell_type(map_position, type_id)
	
func set_pattern_by_cell_type(cell_position: Vector2i, type_id: Cell.TYPES):
	var cell_type = Cell.TYPES.find_key(type_id)
	if(!cell_pattern_dict.has(cell_type)):
		print_debug("Pattern of %s not found." % cell_type)
		return
	var pattern_matrix = cell_pattern_dict[cell_type]
	
	var grid_positions_and_values = find_grid_positions_relative_to_cell(
				cell_position, 
				pattern_matrix
	)
	
	for pos_with_value in grid_positions_and_values:
		if(is_spot_valid(pos_with_value)):
			var pos = Vector2i(pos_with_value.x, pos_with_value.y)
			var value_to_set = pos_with_value.z
			set_cell(0, pos, 0, Vector2i(value_to_set-1,0))
			grid_state[pos.x][pos.y] = value_to_set
	
	
func is_spot_valid(next_pos: Vector3i) -> bool:
	var x = next_pos.x
	var y = next_pos.y
	var value = next_pos.z
	if(x < 0 || x >= grid_state.size()):
		return false
	if(y < 0 || y >= grid_state[0].size()):
		return false
	if(grid_state[x][y] >= value):
		return false
	return true
	
	
func find_grid_positions_relative_to_cell(
	cell_position: Vector2i, 
	matrix : Array
) -> Array[Vector3i]:
	var matrix_x_size = matrix.size()
	var matrix_y_size = matrix[0].size()
	
	var offset_x = cell_position.x - (matrix_x_size/2) 
	var offset_y = cell_position.y - (matrix_y_size/2)
	
	var relative_positions = [] as Array[Vector3i]
	
	for x in matrix_x_size:
		for y in matrix_y_size:
			var pos_x = offset_x + x
			var pos_y = offset_y + y
			var value = int(matrix[x][y])
			relative_positions.append(Vector3i(pos_x, pos_y, value))
	return relative_positions
	
func _on_simulation_ui_on_grid_toggle(substance_type):
	set_layer_enabled(0, !is_layer_enabled((0)))
