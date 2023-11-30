class_name TileMapController extends TileMap

const utils = preload("res://src/utils/matrix_utils.gd")
var GridState = preload("res://src/controller/grid_state.gd")

enum SUBSTANCE_TYPE {IL2, IL4, IL5, IL6, CS}

const NUM_THREADS: int = 4
var grid_states: Dictionary = {}
var grid_to_update: int = 0
var cell_pattern_dict: Dictionary = {}
var grid_size_x: int
var grid_size_y: int
var update_cooldown: float = 0.01
var update_timer: float = update_cooldown
var diffusion_decay_cooldown: float = 0.01
var diffusion_decay_timer: float = diffusion_decay_cooldown
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
	self.remove_layer(0)

	grid_size_x = viewport_size.x / cell_size.x
	grid_size_y = viewport_size.y / cell_size.y 
	
	for substance in SUBSTANCE_TYPE.values():
		grid_states[substance] = GridState.new(grid_size_x + 2, grid_size_y + 2)
		self.add_layer(substance)
		self.set_layer_enabled(substance, false)
		
func _process(delta):
	diffusion_decay_timer += delta
	if diffusion_decay_timer > diffusion_decay_cooldown:
		grid_to_update = (grid_to_update + 1) % 5
		var substance = SUBSTANCE_TYPE.values()[grid_to_update]
		grid_states[substance].add_diffusion_and_decay_parallel()
		diffusion_decay_timer = 0.0
	
	update_timer += delta
	if update_timer > update_cooldown: 
		update_tile_map()
		update_timer = 0.0
		
	for substance in grid_states:
		grid_states[substance].old = grid_states[substance].current.duplicate(true)

func _on_pathogen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position: Vector2i = self.local_to_map(cell_position)
	grid_states[SUBSTANCE_TYPE.CS].add_emanate_pattern(map_position, type_id, cell_pattern_dict)
	# FIXME: only for debugging
	grid_states[SUBSTANCE_TYPE.IL4].add_emanate_pattern(map_position, type_id, cell_pattern_dict)

# The logic is as follows: compare the values in the old grid state with the 
# current ones and update the cells only when they differ to reduce the number
# of set_cell calls. To reduce the number of calls further round to the nearest
# interval of size 1/ntiles in 0..1. 
func update_tile_map():
	var substance = SUBSTANCE_TYPE.values()[grid_to_update]
	if !grid_states[substance].is_displayed:
		return
		
	for x in grid_size_x:
		for y in grid_size_y:
			var old_value: float = grid_states[substance].old[x+1][y+1]
			old_value = round(old_value * ntiles ) / ntiles
			var current_value: float = grid_states[substance].current[x+1][y+1]
			current_value = round(current_value * ntiles ) / ntiles
			if current_value != old_value:
				var pos: Vector2i = Vector2i(x, y)
				var value: float = max(0, min(1, current_value))
				var tile_idx: int = int(value * (ntiles - 1))
				var tile: Vector2i = Vector2i(tile_idx, 0)
				set_cell(substance, pos, substance, tile)

func _update_tile_map_rows(start_row: int, end_row: int, substance: int, current_grid_state: Array, old_grid_state: Array):
	for x in range(start_row, end_row):
		for y in grid_size_y:
			var old_value: float = old_grid_state[x+1][y+1]
			old_value = round(old_value * ntiles ) / ntiles
			var current_value: float = current_grid_state[x+1][y+1]
			current_value = round(current_value * ntiles ) / ntiles
			if current_value != old_value:
				var pos: Vector2i = Vector2i(x, y)
				var value: float = max(0, min(1, current_value))
				var tile_idx: int = int(value * (ntiles - 1))
				var tile: Vector2i = Vector2i(tile_idx, 0)
				call_deferred("set_cell", substance, pos, substance, tile)

func update_tile_map_parallel():
	var threads = []
	for substance in SUBSTANCE_TYPE.values():
		if !grid_states[substance].is_displayed:
			continue

		var current_grid_state = grid_states[substance].current
		var old_grid_state = grid_states[substance].old

		for i in range(NUM_THREADS):
			var start_row: int = i * grid_size_x / NUM_THREADS
			var end_row: int = (i + 1) * grid_size_x / NUM_THREADS

			var thread = Thread.new()
			thread.start(_update_tile_map_rows.bind(start_row, end_row, substance, current_grid_state, old_grid_state))
			threads.append(thread)

	for thread in threads:
		thread.wait_to_finish()

func update_entire_tile_map():
	for substance in SUBSTANCE_TYPE.values():
		if !grid_states[substance].is_displayed:
			continue
		for x in grid_size_x:
			for y in grid_size_y:
				var pos: Vector2i = Vector2i(x, y)
				var value: float = max(0, min(1, grid_states[substance].current[x+1][y+1]))
				var tile_idx: int = int(value * (ntiles - 1))
				var tile: Vector2i = Vector2i(tile_idx, 0)
				set_cell(substance, pos, substance, tile)

func _on_simulation_ui_on_grid_toggle(substance_type):
	var is_substance_enabled = grid_states[substance_type].is_displayed
	grid_states[substance_type].is_displayed = !is_substance_enabled
	self.set_layer_enabled(substance_type, !is_substance_enabled)
	self.update_entire_tile_map()
