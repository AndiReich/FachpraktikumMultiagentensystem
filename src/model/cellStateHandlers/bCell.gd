class_name BCell extends CellStateHandler

func _init():
	var base = Image.load_from_file("res://assets/cells/BCell.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture
	
func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate():
	# handle collision with antigen presenting cell via signals and then differenciate
	# TODO: Change this once collision works
	return ActivatedTHelperCellT4.new(12)
	
func generate():
	
	print_debug("T4 helper cell does not generate.")
	
func emanate():
	print_debug("T4 helper cell does not emanate.")
