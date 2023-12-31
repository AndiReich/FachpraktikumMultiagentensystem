class_name GridStateHandler

const utils = preload("res://src/utils/matrix_utils.gd")

const NUM_THREADS = 4
var old: Array = []
var current: Array = [] 
var grid_size_x: int
var grid_size_y: int
var decay_rate: float = 0.00005
var min_decay: float = 0.0025
var diffusion_coefficient: float = 0.1
var ntiles: int = 10 	# FIXME: assign dynamically based on the number of tiles 
						# in the current tile set
var is_displayed: bool = false

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
	self.current = utils.set_matrix_edges_to_float(self.current, 0.0)
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

func add_diffusion_and_decay():
	self.current = utils.set_matrix_edges_to_float(self.current, 0.0)
	var diffusion_contribution: Array = utils.multiply_matrix_by_float(self.current, self.diffusion_coefficient)
	var weighted_diffusion_contribution: Array = utils.multiply_matrix_by_float(diffusion_contribution, 0.25)
	var remainder: Array = utils.subtract_matrix(self.current, diffusion_contribution)
	var north: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 0)
	var east: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 1)
	var south: Array = utils.roll_matrix(weighted_diffusion_contribution, 1, 0)
	var west: Array = utils.roll_matrix(weighted_diffusion_contribution, -1, 1)
	
	for x in grid_size_x:
		for y in grid_size_y:
			var diffusion_update: float = remainder[x][y] + north[x][y] + east[x][y] + south[x][y] + west[x][y]
			var decay: float = max(self.min_decay, self.decay_rate * diffusion_update)
			var updated_value: float = diffusion_update - decay
			self.current[x][y] = updated_value if updated_value >= 0.0 else 0.0 

func add_diffusion_and_decay_kernel():
	var diffusion_coefficient_quarter: float = self.diffusion_coefficient * 0.25

	for x in range(grid_size_x):
		for y in range(grid_size_y):
			var diffusion_update = self.current[x][y] - self.diffusion_coefficient * self.current[x][y]
			diffusion_update += diffusion_coefficient_quarter * self.current[(x - 1 + grid_size_x) % grid_size_x][y]
			diffusion_update += diffusion_coefficient_quarter * self.current[(x + 1) % grid_size_x][y]
			diffusion_update += diffusion_coefficient_quarter * self.current[x][(y - 1 + grid_size_y) % grid_size_y]
			diffusion_update += diffusion_coefficient_quarter * self.current[x][(y + 1) % grid_size_y]

			var decay: float = max(self.min_decay, self.decay_rate * diffusion_update)
			var updated_value: float = diffusion_update - decay
			self.current[x][y] = max(updated_value, 0.0)

func add_diffusion_and_decay_parallel():
	var diffusion_coefficient_quarter: float = 0.25 * self.diffusion_coefficient
	var threads = []
	
	# prevent diffusion across simulation box borders
	current = utils.set_matrix_edges_to_float(current, 0.0)
	
	for i in range(NUM_THREADS):
		var start_row: int = i * grid_size_x / NUM_THREADS
		var end_row: int = (i + 1) * grid_size_x / NUM_THREADS

		var thread = Thread.new()
		thread.start(_add_diffusion_and_decay_in_rows.bind(start_row, end_row, diffusion_coefficient_quarter, self.decay_rate))
		threads.append(thread)

	for thread in threads:
		thread.wait_to_finish()

func _add_diffusion_and_decay_in_rows(start_row, end_row, diffusion_coefficient_quarter, decay_rate):
	for x in range(start_row, end_row):
		for y in range(grid_size_y):
			var current_value: float = self.current[x][y]
			var diffusion_update: float = current_value - self.diffusion_coefficient * current_value
			diffusion_update += diffusion_coefficient_quarter * self.current[(x - 1 + grid_size_x) % grid_size_x][y]
			diffusion_update += diffusion_coefficient_quarter * self.current[(x + 1) % grid_size_x][y]
			diffusion_update += diffusion_coefficient_quarter * self.current[x][(y - 1 + grid_size_y) % grid_size_y]
			diffusion_update += diffusion_coefficient_quarter * self.current[x][(y + 1) % grid_size_y]

			var decay: float = max(self.min_decay, decay_rate * diffusion_update)
			var updated_value: float = diffusion_update - decay
			self.current[x][y] = max(updated_value, 0.0)

func add_emanate_pattern(cell_position: Vector2i, substance_type_id: TileMapController.SUBSTANCE_TYPE, substance_pattern_dict: Dictionary):
	var substance_type: String = TileMapController.SUBSTANCE_TYPE.find_key(substance_type_id)
	if(!substance_pattern_dict.has(substance_type)):
		return
	var pattern_matrix: Array = substance_pattern_dict[substance_type]
	var matrix_x_size: int = pattern_matrix.size()
	var matrix_y_size: int = pattern_matrix[0].size()
	var offset_x: int = cell_position.x - (matrix_x_size/2) + 1
	var offset_y: int = cell_position.y - (matrix_y_size/2) + 1
	
	for local_x in pattern_matrix.size():
		var global_x: int = offset_x + local_x
		for local_y in pattern_matrix[0].size():
			var global_y: int = offset_y + local_y
			var value: float = float(pattern_matrix[local_x][local_y]) / self.ntiles
			if(is_position_valid(global_x, global_y)):
				self.current[global_x][global_y] = min(self.current[global_x][global_y] + value, 1.0)
	
# Not that it matters, but we could check for valid positions in each loop to 
# avoid three if statements per x,y iteration in add_emanate_pattern_to_grid.
func is_position_valid(x: int, y: int) -> bool:
	if(x < 0 || x >= self.current.size()):
		return false
	if(y < 0 || y >= self.current[0].size()):
		return false
	return true

func assert_grid_state() -> bool:
	for x in range(grid_size_x):
		for y in range(grid_size_y):
			var value = current[x][y]
			if value < 0.0 or value > 1.0:
				return false
	return true
