class_name TileMapController extends TileMap

const utils = preload("res://src/utils/matrix_utils.gd")

var old_grid_state: Array = []
var current_grid_state: Array = [] 
var patterns_loaded: bool = false
var cell_pattern_dict: Dictionary = {}
var grid_size_x: int
var grid_size_y: int
var decay_rate: float = 0.0001
var min_decay: float = 0.0025
var diffusion_coefficient: float = 0.25
var update_cooldown: float = 0.25
var update_timer: float = update_cooldown
var ntiles: int = 10 	# FIXME: assign dynamically based on the number of tiles 
						# in the current tile set


func _enter_tree(): 
	var reader = CellEmenatePatternReader.new()
	# initialize patterns from config files
	for cell_type in Cell.TYPES:
		var value = reader.read_pattern_for_cell_type(cell_type)
		if(value != []):
			cell_pattern_dict[cell_type] = value


func _ready():
	var cell_size: Vector2i = self.tile_set.tile_size
	var viewport_size: Vector2i = self.get_viewport_rect().size

	grid_size_x = viewport_size.x / cell_size.x
	grid_size_y = viewport_size.y / cell_size.y 
	
	for x in grid_size_x:
		old_grid_state.append([])
		current_grid_state.append([])
		for y in grid_size_y:
			old_grid_state[x].append(0.0)
			current_grid_state[x].append(0.0)


func _process(delta):
	update_timer += delta
	if update_timer > update_cooldown: 
		add_decay_to_grid()
		add_diffusion_simple_to_grid()
		update_timer = 0.0
	update_tile_map()
	old_grid_state = current_grid_state.duplicate(true)


func _on_virus_antigen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position: Vector2i = self.local_to_map(cell_position)
	add_emante_pattern_to_grid(map_position, type_id)


# The logic is as follows: compare the values in the old grid state with the 
# current ones and update the cells only when they differ to reduce the number
# of set_cell calls. To reduce the number of calls further round to the nearest
# interval of size 1/ntiles in 0..1. 
func update_tile_map():
	for x in grid_size_x:
		for y in grid_size_y:
			var old_value: float = round(old_grid_state[x][y] * ntiles ) / ntiles
			var current_value: float = round(current_grid_state[x][y] * ntiles ) / ntiles
			if current_value != old_value:
				var pos: Vector2i = Vector2i(x, y)
				var value: float = max(0, min(1, current_value))
				var tile_idx: int = int(value * (ntiles - 1))
				var tile: Vector2i = Vector2i(tile_idx, 0)
				set_cell(0, pos, 0, tile)


func add_decay_to_grid():
	for x in grid_size_x:
		for y in grid_size_y:
			var decay: float = max(min_decay, decay_rate * current_grid_state[x][y])
			var updated_value: float = current_grid_state[x][y] - decay
			current_grid_state[x][y] = updated_value if updated_value >= 0.0 else 0.0 


func add_diffusion_simple_to_grid():
	var diffusion_contribution: Array = utils.multiply_matrix_by_float(current_grid_state, diffusion_coefficient)
	var weighted_diffusion_contribution: Array = utils.multiply_matrix_by_float(diffusion_contribution, 0.25)
	var remainder: Array = utils.subtract_matrix(current_grid_state, diffusion_contribution)
	var north: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 0)
	var east: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 1)
	var south: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 0)
	var west: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 1)
	
	for x in grid_size_x:
		for y in grid_size_y:
			current_grid_state[x][y] = remainder[x][y] + north[x][y] + east[x][y] + south[x][y] + west[x][y]


func add_emante_pattern_to_grid(cell_position: Vector2i, type_id: Cell.TYPES):
	var cell_type: String = Cell.TYPES.find_key(type_id)
	if(!cell_pattern_dict.has(cell_type)):
		print_debug("Pattern of %s not found." % cell_type)
		return
	var pattern_matrix: Array = cell_pattern_dict[cell_type]
	var matrix_x_size: int = pattern_matrix.size()
	var matrix_y_size: int = pattern_matrix[0].size()
	var offset_x: int = cell_position.x - (matrix_x_size/2) 
	var offset_y: int = cell_position.y - (matrix_y_size/2)
	
	for local_x in pattern_matrix.size():
		var global_x: int = offset_x + local_x
		for local_y in pattern_matrix[0].size():
			var global_y: int = offset_y + local_y
			var value: float = float(pattern_matrix[local_x][local_y])
			if(is_position_valid(global_x, global_y, value)):
				current_grid_state[global_x][global_y] += value / self.ntiles


# Not that it matters, but we could check for valid positions in each loop to 
# avoid three if statements per x,y iteration in add_emanate_pattern_to_grid.
func is_position_valid(x: int, y: int, value: float) -> bool:
	if(x < 0 || x >= current_grid_state.size()):
		return false
	if(y < 0 || y >= current_grid_state[0].size()):
		return false
	return true
