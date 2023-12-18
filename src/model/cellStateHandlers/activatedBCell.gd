class_name ActivatedBCell extends CellStateHandler

const DIFFERENCIATION_TARGET = Cell.TYPES.PLASMACYTE
const MOVEMENT_TARGETS = []

const TRY_DIFFERENCIATION_COOLDOWN: float = 0.5
var try_differenciation_timer: float = 0.0

	
func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ACTIVATEDBCELL
	var base = Image.load_from_file("res://assets/cells/BCell.png")
	var overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
	# Differenciation logic
	# IL based differenciation
	if(try_differenciation_timer > TRY_DIFFERENCIATION_COOLDOWN):
		if(await should_differenciate(cell)):
			differenciate(cell, color_code)
		try_differenciation_timer = 0.0
	try_differenciation_timer += delta
	
	
func move(delta: float, cell: Cell, target: Cell):
	var random_value = randi_range(0,1)
	if random_value == 0:
		grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL4)
	else:
		grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL5)
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	# generate new B Cells if a concentration of IL2, IL4 and IL5 is high enough
	return
	
func emanate(cell: Cell):
	print_debug("Activated b cell does not emanate.")
	
func should_differenciate(cell: Cell) -> bool:
	var caller_id = cell.get_instance_id()
	cell.fetch_grid_value.emit(cell.position, TileMapController.SUBSTANCE_TYPE.IL5, caller_id)
	var grid_state_value = int(floor(await cell.grid_state_value_response*9))
	
	var random = randf_range(0.0,1.0)
	if(grid_state_value == 0 || grid_state_value == 9):
		if(class_weights[int(grid_state_value)] > random):
			return true
		else:
			return false

	if(class_weights[int(grid_state_value)-1] < random && class_weights[int(grid_state_value)+1] > random):
		return true
	
	return false
	
	
	
	
	
