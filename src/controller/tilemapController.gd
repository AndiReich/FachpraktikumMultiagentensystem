class_name TileMapController extends TileMap

const utils = preload("res://src/utils/matrix_utils.gd")
var GridState = preload("res://src/controller/grid_state.gd")

enum SUBSTANCE_TYPE {IL2, IL4, IL5, IL6, CS}

var grid_states: Dictionary = {}

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
	
	for substance_type in SUBSTANCE_TYPE:
		grid_states[substance_type] = GridState.new(grid_size_x, grid_size_y)


func _process(delta):
	update_timer += delta
	if update_timer > update_cooldown: 
		for substance in grid_states:
			grid_states[substance].add_decay()
			grid_states[substance].add_diffusion()
		update_timer = 0.0
	update_tile_map()
	for substance in grid_states:
		grid_states[substance].old = grid_states[substance].current.duplicate(true)


func _on_virus_antigen_emanate(cell_position : Vector2, type_id: Cell.TYPES):
	var map_position: Vector2i = self.local_to_map(cell_position)
	grid_states["CS"].add_emanate_pattern(map_position, type_id, cell_pattern_dict)

# The logic is as follows: compare the values in the old grid state with the 
# current ones and update the cells only when they differ to reduce the number
# of set_cell calls. To reduce the number of calls further round to the nearest
# interval of size 1/ntiles in 0..1. 
func update_tile_map():
	for x in grid_size_x:
		for y in grid_size_y:
			var old_value: float = round(grid_states["CS"].old[x][y] * ntiles ) / ntiles
			var current_value: float = round(grid_states["CS"].current[x][y] * ntiles ) / ntiles
			if current_value != old_value:
				var pos: Vector2i = Vector2i(x, y)
				var value: float = max(0, min(1, current_value))
				var tile_idx: int = int(value * (ntiles - 1))
				var tile: Vector2i = Vector2i(tile_idx, 0)
				set_cell(0, pos, 0, tile)


