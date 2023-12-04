class_name Plasmacyte extends CellStateHandler

const MOVEMENT_TARGETS = null

func _init(color_code: int):
	cell_type = Cell.TYPES.PLASMACYTE
	var base = Image.load_from_file("res://assets/cells/Plasmacyte.png")
	var overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, MOVEMENT_TARGETS)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Plasmacyte does not differenciate.")
	
# generate or emanate Antibodies randomly when IL6 concentration is high enough
func generate():
	# Andi: I think generate makes the most sense for the Antibodies since we want them to be visible.
	# Also, should an Antibody be a cell or something seperate?
	# print_debug("Plasmacyte does not generate.")
	return
	
func emanate(cell: Cell):
	# print_debug("Plasmacyte does not emanate.")
	return
