class_name Plasmacyte extends CellStateHandler

var agent_scene = preload("res://scenes/agents/agent.tscn")

const MOVEMENT_TARGETS = []

var IL6 = TileMapController.SUBSTANCE_TYPE.IL6
var il6_threshold: float = 0.5
var generate_cooldown: float = 5.0
var generate_timer: float = generate_cooldown

const DEATH_START_COOLDOWN: float = 5
var death_timer: float = 0

func _init(color_code: int):
	self.color_code = color_code
	self.cell_type = Cell.TYPES.PLASMACYTE
	var base = Image.load_from_file("res://assets/cells/Plasmacyte.png")
	var overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	generate_timer += delta
	if generate_timer > generate_cooldown:
		_try_generate(cell)
	move(delta, cell, closest_neighbor)
	
	if(death_timer > DEATH_START_COOLDOWN):
		death_timer = 0.0
		try_to_die(cell)
	death_timer += delta
	
func move(delta: float, cell: Cell, target: Cell):
	grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL6)
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Plasmacyte does not differenciate.")
	
func _try_generate(cell: Cell):
	# check IL6 value on grid
	var caller_id = cell.get_instance_id()
	cell.fetch_grid_value.emit(cell.position, IL6, caller_id)
	var il6_value = await cell.grid_state_value_response
	# if threshold is met, produce antibody of specific type
	if il6_value >= il6_threshold:
		var antibody = agent_scene.instantiate(self.color_code)
		antibody.initialize_by_cell_type(Cell.TYPES.ANTIBODY, self.color_code, range_of_mutations)
		antibody.position = cell.position
		cell.agent_root_node.add_child(antibody)
		generate_timer = 0.0 
	
func emanate(cell: Cell):
	print_debug("Plasmacyte does not emanate.")

func try_to_die(cell):
	# 5 chance to die every 5 seconds
	var random_float = randf_range(0,1)
	if(random_float < 0.10):
		cell.queue_free()
