class_name GridStateHandler

const utils = preload("res://src/utils/matrix_utils.gd")

var old: Array = []
var current: Array = [] 
var patterns_loaded: bool = false
var grid_size_x: int
var grid_size_y: int
var decay_rate: float = 0.0001
var min_decay: float = 0.0025
var diffusion_coefficient: float = 0.25
var ntiles: int = 10 	# FIXME: assign dynamically based on the number of tiles 
						# in the current tile set

func _init(grid_size_x_in: int, grid_size_y_in: int):
	grid_size_x = grid_size_x_in
	grid_size_y = grid_size_y_in
	
	for x in grid_size_x:
		old.append([])
		current.append([])
		for y in grid_size_y:
			old[x].append(0.0)
			current[x].append(0.0)

func add_decay():
	for x in grid_size_x:
		for y in grid_size_y:
			var decay: float = max(self.min_decay, self.decay_rate * self.current[x][y])
			var updated_value: float = self.current[x][y] - decay
			self.current[x][y] = updated_value if updated_value >= 0.0 else 0.0 

func add_diffusion():
	var diffusion_contribution: Array = utils.multiply_matrix_by_float(self.current, self.diffusion_coefficient)
	var weighted_diffusion_contribution: Array = utils.multiply_matrix_by_float(diffusion_contribution, 0.25)
	var remainder: Array = utils.subtract_matrix(self.current, diffusion_contribution)
	var north: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 0)
	var east: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 1)
	var south: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 0)
	var west: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 1)
	
	for x in grid_size_x:
		for y in grid_size_y:
			self.current[x][y] = remainder[x][y] + north[x][y] + east[x][y] + south[x][y] + west[x][y]

func add_emanate_pattern(cell_position: Vector2i, type_id: Cell.TYPES, cell_pattern_dict: Dictionary):
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
			var value: float = float(pattern_matrix[local_x][local_y]) / self.ntiles
			if(is_position_valid(global_x, global_y, value)):
				self.current[global_x][global_y] += value 

# Not that it matters, but we could check for valid positions in each loop to 
# avoid three if statements per x,y iteration in add_emanate_pattern_to_grid.
func is_position_valid(x: int, y: int, value: float) -> bool:
	if(x < 0 || x >= self.current.size()):
		return false
	if(y < 0 || y >= self.current[0].size()):
		return false
	if(self.current[x][y] >= 1.0):
		return false
	return true
