class_name Macrophage extends CellStateHandler

func _init():
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	# should move towards antigen
	super.move(delta,cell)
	
func differenciate():
	# handle collision with antigen via signals and then differenciate
	# TODO: Change once its done
	return AntigenPresentingCell.new(12)
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate():
	print_debug("Macrophage does not emanate.")
