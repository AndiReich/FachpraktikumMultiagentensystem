class_name Antibody extends CellStateHandler

func _init(color_code: int):
	cell_type = Cell.TYPES.ANTIBODY
	var base = Image.load_from_file("res://assets/cells/Antibody.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, Cell.TYPES.PATHOGEN)
	move(delta, cell, closest_neighbor)
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antibody does not differentiate.")
	
func generate():
	print_debug("Antibody does not generate.")
	
func emanate(cell: Cell):
	print_debug("Antibody does not emanate.")
