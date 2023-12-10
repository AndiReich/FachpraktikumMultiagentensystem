class_name AntigenPresentingCell extends CellStateHandler

const MOVEMENT_TARGETS = [Cell.TYPES.BCELL, Cell.TYPES.THELPERCELL]

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ANTIGENPRESENTINGCELL
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
	var overlay = Image.load_from_file("res://assets/cells/MacrophageOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate():
	print_debug("Antigen presenting cell does not generate.")
	
func emanate(cell: Cell):
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
