class_name Pathogen extends CellStateHandler

@export var num_antibodies_to_kill: int = 4

var attached_antibodies: Array = []

func _init(color_code: int):
	cell_type = Cell.TYPES.PATHOGEN
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, null)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate(cell)
		emanate_timer = 0.0
	if collisions:
		handle_antibody_collisions(cell, collisions)
	try_die(cell)

func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antigen does not differenciate.")
	
func generate():
	# should antigens reproduce or not?
	print_debug("Antigen does not generate.")

func emanate(cell: Cell):
	# emanates chemotactic substances
	cell.pathogen_emanate.emit(cell.global_position, cell.TYPES.PATHOGEN)

func _antibody_filter(collider): 
	if collider.cell_state_handler.cell_type == Cell.TYPES.ANTIBODY: 
		return collider

func handle_antibody_collisions(cell: Cell, collisions: Array):
	collisions = collisions.filter(_antibody_filter)
	for collider in collisions:
		if collider not in attached_antibodies:
			attached_antibodies.append(collider)

func try_die(cell: Cell):
	if attached_antibodies.size() >= num_antibodies_to_kill:
		cell.queue_free()
		cell = null
		for antibody in attached_antibodies:
			antibody.queue_free()
			antibody = null
