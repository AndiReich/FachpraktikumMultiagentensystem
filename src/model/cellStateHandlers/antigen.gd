class_name Antigen extends CellStateHandler

var cell: Cell

func _init(color_code: int):
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array):
	self.cell = cell

	var closest_neighbor = super.find_closest_neighbor(cell, neighbors)

	move(delta, cell)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate()
		emanate_timer = 0.0

func move(delta: float, cell: Cell):
	# moves towards next antibody?
	super.move(delta,cell)
	
func differenciate():
	print_debug("Antigen does not differenciate.")
	
func generate():
	# should antigens reproduce or not?
	print_debug("Antigen does not generate.")

func emanate():
	# emanates chemotactic substances
	cell.antigen_emanate.emit(cell.global_position, cell.TYPES.ANTIGEN)
