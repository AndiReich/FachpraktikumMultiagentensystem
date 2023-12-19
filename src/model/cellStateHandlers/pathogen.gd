class_name Pathogen extends CellStateHandler

@export var num_antibodies_to_kill: int = 4

const MOVEMENT_TARGETS = []
var attached_antibodies: Array = []

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.PATHOGEN
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate(cell)
		emanate_timer = 0.0
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
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.CS)

func remove_attached_antibodies():
	for antibody in attached_antibodies:
		if is_instance_valid(antibody):
			antibody.queue_free()

func try_die(cell: Cell):
	if attached_antibodies.size() >= num_antibodies_to_kill:
		remove_attached_antibodies()
		cell.queue_free()
		

func _on_antibody_attach_to_pathogen(cell: Cell):
	attached_antibodies.append(cell)

