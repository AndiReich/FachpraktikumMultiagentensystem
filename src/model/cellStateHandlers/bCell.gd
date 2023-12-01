class_name BCell extends CellStateHandler

const DIFFERENCIATION_TRIGGER = Cell.TYPES.ANTIGENPRESENTINGCELL
const DIFFERENCIATION_TARGET = Cell.TYPES.ACTIVATEDBCELL

func _init():
	cell_type = Cell.TYPES.BCELL
	var base = Image.load_from_file("res://assets/cells/BCell.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture
	
func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, null)
	
	# Differenciation logic
	var colliding_cell = find_colliding_cell(cell, collisions, DIFFERENCIATION_TRIGGER)
	if colliding_cell:
		var color_code = colliding_cell.cell_state_handler.color_code
		differenciate(cell, color_code)
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	
	print_debug("T4 helper cell does not generate.")
	
func emanate(cell: Cell):
	print_debug("T4 helper cell does not emanate.")
