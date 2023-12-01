class_name Antibody extends CellStateHandler

var is_attached_to_pathogen: bool = false
var attached_pathogen: Cell = null
var collider_to_cell_transform: Transform2D = Transform2D()

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ANTIBODY
	var base = Image.load_from_file("res://assets/cells/Antibody.png")
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	if !is_attached_to_pathogen:
		var closest_neighbor = super.find_closest_neighbor(cell, neighbors, Cell.TYPES.PATHOGEN)
		var colliding_pathogen = find_colliding_cell(cell, collisions, Cell.TYPES.PATHOGEN)
		if colliding_pathogen:
			handle_pathogen_collision(cell, colliding_pathogen)
		move(delta, cell, closest_neighbor)
	else:
		cell.global_transform = attached_pathogen.get_global_transform() * collider_to_cell_transform
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antibody does not differentiate.")
	
func generate():
	print_debug("Antibody does not generate.")
	
func emanate(cell: Cell):
	print_debug("Antibody does not emanate.")

func handle_pathogen_collision(cell: Cell, collider: Cell):
	if cell.cell_state_handler.color_code != collider.cell_state_handler.color_code:
		return

	self.is_attached_to_pathogen = true
	self.attached_pathogen = collider
	
	cell.cell_state_handler.disable_movement()
	
	var world_to_cell_transform = cell.get_global_transform()
	var world_to_collider_transform = collider.get_global_transform()
	collider_to_cell_transform = world_to_collider_transform.inverse() * world_to_cell_transform
	
	cell.global_transform = collider.get_global_transform() * collider_to_cell_transform
