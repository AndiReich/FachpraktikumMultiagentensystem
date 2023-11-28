class_name TileMapController extends TileMap

const utils = preload("res://src/utils/matrix_utils.gd")
var GridState = preload("res://src/controller/grid_state.gd")

enum SUBSTANCE_TYPE {IL2, IL4, IL5, IL6, CS}

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
		self.set_layer_modulate(substance, Color(255, 255, 255, 0.5))

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

func _on_virus_antigen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position: Vector2i = self.local_to_map(cell_position)
	grid_states[SUBSTANCE_TYPE.CS].add_emanate_pattern(map_position, type_id, cell_pattern_dict)
	# FIXME: only for debugging
	grid_states[SUBSTANCE_TYPE.IL4].add_emanate_pattern(map_position, type_id, cell_pattern_dict)

# The logic is as follows: compare the values in the old grid state with the 
# current ones and update the cells only when they differ to reduce the number
# of set_cell calls. To reduce the number of calls further round to the nearest
# interval of size 1/ntiles in 0..1. 
func update_tile_map():
	for substance in SUBSTANCE_TYPE.values():
		if grid_states[substance].is_displayed:
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

func update_entire_tile_map():
	for substance in SUBSTANCE_TYPE.values():
		if grid_states[substance].is_displayed:
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
