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
	print("Tries handling emanate.")
	
	
	var local_position : Vector2 = to_local(position)
	var map_position : Vector2i = local_to_map(local_position)
	
	
	print("local coords = x: %d, y: %d" % [local_position.x, local_position.y])
	print("map coords   = x: %d, y: %d" % [map_position.x, map_position.y])
	set_cell(0, Vector2i(map_position.x,map_position.y), 0, Vector2i(3,0))
	print("Handled emit")

func preCheckPatternAgainstGrid():
	print("test")
	
func setPatternForCell():
	print("test")
