class_name AntigenPresentingCell extends CellStateHandler

func _init(color_code: int):
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
	var overlay = Image.load_from_file("res://assets/cells/MacrophageOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture


func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate():
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate():
	print_debug("Antigen presenting cell does not generate.")
	
func emanate():
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
