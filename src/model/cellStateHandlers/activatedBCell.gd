class_name ActivatedBCell extends CellStateHandler

	
func _init(color_code: int):
	var base = Image.load_from_file("res://assets/cells/BCell.png")
	var overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
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
	# maybe something like each x ticks there is a chance for differenciation to either B cell or P Cell
	if(true):
		return BCell.new()
	else:
		# TODO: Change when implementing
		return Plasmacyte.new(12)
	
func generate():
	# generate new B Cells if a concentration of IL2, IL4 and IL5 is high enough
	return
	
func emanate():
	print_debug("Activated b cell does not emanate.")
