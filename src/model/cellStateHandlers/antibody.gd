class_name Antibody extends CellStateHandler

const MOVEMENT_TARGETS = [Cell.TYPES.PATHOGEN]

const GRID_MOVEMENT_COOLDOWN = 0.5
var grid_movement_timer = 0

const math_utils = preload("res://src/utils/math_utils.gd")

var is_attached_to_pathogen: bool = false
var attached_pathogen: Cell = null
var collider_to_cell_transform: Transform2D = Transform2D()
var antigen_recognition_cooldown: float = 5.0
var antigen_recognition_timer: float = antigen_recognition_cooldown

const DEATH_START_COOLDOWN: float = 5
var death_timer: float = 0

signal antibody_attach_to_pathogen(cell: Cell)

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ANTIBODY
	var base = Global.antibody_image
	var modified_image = color_utils.get_specific_permutation(base, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	if !is_attached_to_pathogen:
		antigen_recognition_timer += delta
		var closest_neighbor = null
		var colliding_pathogen = find_colliding_cell(cell, collisions, Cell.TYPES.PATHOGEN)
		if colliding_pathogen and antigen_recognition_timer > antigen_recognition_cooldown:
			handle_pathogen_collision(cell, colliding_pathogen)
			antigen_recognition_timer = 0.0
		else:
			closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
		move(delta, cell, closest_neighbor)
		
		if(death_timer > DEATH_START_COOLDOWN):
			death_timer = 0.0
			try_to_die(cell)
		death_timer += delta
	else:
		# need to make sure the node is still valid when potentially removing them at the death event 
		# of a virus
		if is_instance_valid(attached_pathogen) and is_instance_valid(cell):
			cell.global_transform = attached_pathogen.get_global_transform() * collider_to_cell_transform
			
	
	
func move(delta: float, cell: Cell, target: Cell):
	if(grid_movement_timer > GRID_MOVEMENT_COOLDOWN):
		super.grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.CS)
		grid_movement_timer = 0
	grid_movement_timer += delta
	
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antibody does not differentiate.")
	
func generate():
	print_debug("Antibody does not generate.")
	
func emanate(cell: Cell):
	print_debug("Antibody does not emanate.")

func handle_pathogen_collision(cell: Cell, collider: Cell):
	# check if the antigen codes match
	var antibody_antigen_code = cell.cell_state_handler.color_code
	var pathogen_antigen_code = collider.cell_state_handler.color_code
	var is_antigen_code_match = recognize_antigen(antibody_antigen_code, pathogen_antigen_code)
	if !is_antigen_code_match:
		return

	self.is_attached_to_pathogen = true
	self.attached_pathogen = collider
	
	# disable active movement of antibody to move with pathogen after attachment
	cell.cell_state_handler.disable_movement()
	
	# logic for movement after sticking to pathogen
	var world_to_cell_transform = cell.get_global_transform()
	var world_to_collider_transform = collider.get_global_transform()
	collider_to_cell_transform = world_to_collider_transform.inverse() * world_to_cell_transform
	cell.global_transform = collider.get_global_transform() * collider_to_cell_transform
	
	# inform the pathogen that an antibody was attached
	antibody_attach_to_pathogen.connect(collider.cell_state_handler._on_antibody_attach_to_pathogen)
	antibody_attach_to_pathogen.emit(cell)

func recognize_antigen(antibody_antigen_code: int, pathogen_antigen_code: int):
	var matching_bits: int = math_utils.count_matching_bits(antibody_antigen_code, pathogen_antigen_code, antigen_code_bitlength)
	var is_recognized = antigen_recognition_function(matching_bits) > randf()
	return is_recognized

# sigmoid activation function which maps the number of matching antigen code bits
# to a value between 0 and 1
static func antigen_recognition_sigmoid_function(x: float) -> float:
	return 1 / (1 + exp(-2 * (x - 2)))

# debug recognition function: #matching bits -> binding probability
# 0 ->   0.0000%
# 1 ->   1.5625%
# 2 ->   6.2500%
# 3 ->  25.0000%
# 4 -> 100.0000%
static func antigen_recognition_function(x: int) -> float:
	if x == 0:
		return 0.000000
	elif x == 1: 
		return 0.015625
	elif x == 2: 
		return 0.062500
	elif x == 3: 
		return 0.250000
	elif x == 4:
		return 1.000000
	return -1
	
func try_to_die(cell):
	# 5 chance to die every 5 seconds
	var random_float = randf_range(0,1)
	if(random_float < 0.25):
		if is_instance_valid(cell):
			cell.queue_free()
