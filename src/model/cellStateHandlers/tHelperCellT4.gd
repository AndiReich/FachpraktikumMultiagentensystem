class_name THelperCellT4 extends CellStateHandler

func _init():
	cell_type = Cell.TYPES.THELPERCELL
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, null)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell, target: Cell):
	# should probably move randomly
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	# handle collision with antigen presenting cell via signals and then differenciate
	# TODO: Change this once collision works
	return ActivatedTHelperCellT4.new(color_code)
	
func generate():
	print_debug("T4 helper cell does not generate.")
	
func emanate(cell: Cell):
	print_debug("T4 helper cell does not emanate.")
