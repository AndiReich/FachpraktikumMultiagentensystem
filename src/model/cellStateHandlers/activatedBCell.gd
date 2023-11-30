class_name ActivatedBCell extends CellStateHandler

	
func _init(color_code: int):
	cell_type = Cell.TYPES.ACTIVATEDBCELL
	var base = Image.load_from_file("res://assets/cells/BCell.png")
	var overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, null)
	
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	# maybe something like each x ticks there is a chance for differenciation to either B cell or P Cell
	if(true):
		return BCell.new()
	else:
		# TODO: Change when implementing
		return Plasmacyte.new(12)
	
func generate():
	# generate new B Cells if a concentration of IL2, IL4 and IL5 is high enough
	return
	
func emanate(cell: Cell):
	print_debug("Activated b cell does not emanate.")
