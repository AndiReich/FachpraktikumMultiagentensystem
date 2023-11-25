class_name ActivatedTHelperCellT4 extends CellStateHandler

func _init(color_code: int):
	var base = Image.load_from_file("res://assets/cells/THelperCell.png")
	var overlay = Image.load_from_file("res://assets/cells/THelperCellOverlay.png")
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
	print_debug("Activated t-helper cell T4 does not differenciate.")
	
func generate():
	# generate new T4 Helper cells randomly when ILs levels are high enough
	print("Not implemented yet.")
	
func emanate():
	# emanate ILs 2, 4, 5 and 6
	print("Not implemented yet.")
