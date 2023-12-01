class_name Pathogen extends CellStateHandler

var cell: Cell
var cell_type: Cell.TYPES = Cell.TYPES.PATHOGEN

func _init(color_code: int):
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array):
	self.cell = cell
	move(delta, cell, null)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate()
		emanate_timer = 0.0

func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate():
	print_debug("Antigen does not differenciate.")
	
func generate():
	# should antigens reproduce or not?
	print_debug("Antigen does not generate.")

func emanate():
	# emanates chemotactic substances
	cell.pathogen_emanate.emit(cell.global_position, cell.TYPES.PATHOGEN)