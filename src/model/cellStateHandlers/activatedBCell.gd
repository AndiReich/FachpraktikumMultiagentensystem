class_name ActivatedBCell extends CellStateHandler

const DIFFERENCIATION_TARGET = Cell.TYPES.PLASMACYTE
const MOVEMENT_TARGETS = []
	
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
	# change this to IL based differenciation
	#var colliding_cell = find_colliding_cell(cell, collisions, DIFFERENCIATION_TRIGGER)
	#if colliding_cell:
	#	var color_code = colliding_cell.cell_state_handler.color_code
	#	differenciate(cell, color_code)
	
	
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
	
