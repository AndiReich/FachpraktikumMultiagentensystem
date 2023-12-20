class_name THelperCellT4 extends CellStateHandler

const DIFFERENCIATION_TRIGGER = Cell.TYPES.ANTIGENPRESENTINGCELL
const DIFFERENCIATION_TARGET = Cell.TYPES.ACTIVATEDTHELPERCELL
const MOVEMENT_TARGETS = [Cell.TYPES.ANTIGENPRESENTINGCELL]

func _init():
	color_code = -1
	cell_type = Cell.TYPES.THELPERCELL
	var base = Global.t_helper_cell_image
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
	# Differenciation logic
	var colliding_cell = find_colliding_cell(cell, collisions, DIFFERENCIATION_TRIGGER)
	if colliding_cell:
		var color_code = colliding_cell.cell_state_handler.color_code
		differenciate(cell, color_code)
		colliding_cell.queue_free()
	
func move(delta: float, cell: Cell, target: Cell):
	# should probably move randomly
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	print_debug("T4 helper cell does not generate.")
	
func emanate(cell: Cell):
	print_debug("T4 helper cell does not emanate.")
