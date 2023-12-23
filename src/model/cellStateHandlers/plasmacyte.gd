class_name Plasmacyte extends CellStateHandler

var agent_scene = preload("res://scenes/agents/agent.tscn")

const MOVEMENT_TARGETS = []
const PROLIFERATE_NEIGHBORS_LIMIT: int = 5
const PROLIFERATE_COLLDOWN: float = 5
const GRID_MOVEMENT_COOLDOWN = 0.5
const DEATH_START_COOLDOWN: float = 5
const IL6 = TileMapController.SUBSTANCE_TYPE.IL6
const IL6_TRESHHOLD: float = 0.5

var grid_movement_timer = 0
var proliferate_timer: float = 0
var death_timer: float = 0

func _init(color_code: int):
	self.color_code = color_code
	self.cell_type = Cell.TYPES.PLASMACYTE
	var base = Global.plasmacyte_image
	var overlay = Global.plasmacyte_overlay
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	
	move(delta, cell, closest_neighbor)
	
	if(death_timer > DEATH_START_COOLDOWN):
		death_timer = 0.0
		try_to_die(cell)
	death_timer += delta
	
	var antibody_neighbors = neighbors.filter(filter_is_antibody)
	if antibody_neighbors.size() < PROLIFERATE_NEIGHBORS_LIMIT:
		generate(cell)
	proliferate_timer += delta

func filter_is_antibody(cell: Cell):
	return cell.cell_state_handler.cell_type == Cell.TYPES.ANTIBODY
	
func move(delta: float, cell: Cell, target: Cell):
	if(grid_movement_timer > GRID_MOVEMENT_COOLDOWN):
		super.grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL6)
		grid_movement_timer = 0
	grid_movement_timer += delta
	
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Plasmacyte does not differenciate.")
	
func generate(cell: Cell):
	if proliferate_timer >= PROLIFERATE_COLLDOWN:
		var caller_id = cell.get_instance_id()
		cell.fetch_grid_value.emit(cell.position, IL6, caller_id)
		var il6_value = await cell.grid_state_value_response
		# if threshold is met, produce antibody of specific type
		if il6_value >= IL6_TRESHHOLD:
			var agent = agent_scene.instantiate(self.color_code)
			agent.initialize_by_cell_type(Cell.TYPES.ANTIBODY, self.color_code, range_of_mutations)
			agent.position = cell.position
			cell.agent_root_node.add_child(agent)
			proliferate_timer = 0
	
func emanate(cell: Cell):
	print_debug("Plasmacyte does not emanate.")

func try_to_die(cell):
	# 5 chance to die every 5 seconds
	var random_float = randf_range(0,1)
	if(random_float < 0.05):
		cell.queue_free()
