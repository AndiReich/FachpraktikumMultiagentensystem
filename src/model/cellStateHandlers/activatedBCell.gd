class_name ActivatedBCell extends CellStateHandler

var agent_scene = preload("res://scenes/agents/agent.tscn")

const DIFFERENCIATION_TARGET = Cell.TYPES.PLASMACYTE
const MOVEMENT_TARGETS = []

const TRY_DIFFERENCIATION_COOLDOWN: float = 5
const GRID_MOVEMENT_COOLDOWN = 0.5
const DEACTIVATION_COOLDOWN: float = 30
const PROLIFERATE_NEIGHBORS_LIMIT: int = 3
const PROLIFERATE_COLLDOWN: float = 2.5
const IL4_TRESHHOLD : float = 0.4

var IL4 = TileMapController.SUBSTANCE_TYPE.IL4
var try_differenciation_timer: float = 0.0
var deactivation_timer: float = 0
var grid_movement_timer = 0
var proliferate_timer: float = 0

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ACTIVATEDBCELL
	var base = Global.b_cell_image
	var overlay = Global.b_cell_overlay
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
	var act_b_cell_neighbors = neighbors.filter(filter_is_b_cell)
	if act_b_cell_neighbors.size() < PROLIFERATE_NEIGHBORS_LIMIT:
		generate(cell)
	proliferate_timer += delta
	
	# Differenciation logic
	# IL based differenciation
	if(try_differenciation_timer > TRY_DIFFERENCIATION_COOLDOWN):
		if(await should_differenciate(cell)):
			differenciate(cell, color_code)
		try_differenciation_timer = 0.0
	try_differenciation_timer += delta
	
	if(deactivation_timer > DEACTIVATION_COOLDOWN):
		deactivation_timer = 0.0
		deactivate(cell)
	deactivation_timer += delta

func filter_is_b_cell(cell: Cell):
	return (cell.cell_state_handler.cell_type == Cell.TYPES.ACTIVATEDBCELL 
	|| cell.cell_state_handler.cell_type == Cell.TYPES.BCELL)

func move(delta: float, cell: Cell, target: Cell):
	var random_value = randi_range(0,1)
	if(grid_movement_timer > GRID_MOVEMENT_COOLDOWN):
		if random_value == 0:
			grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL4)
		else:
			grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL5)
		grid_movement_timer = 0
	grid_movement_timer += delta
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate(cell: Cell):
	if proliferate_timer >= PROLIFERATE_COLLDOWN:
		var caller_id = cell.get_instance_id()
		cell.fetch_grid_value.emit(cell.position, IL4, caller_id)
		var il4_value = await cell.grid_state_value_response
		if il4_value >= IL4_TRESHHOLD:
			var agent = agent_scene.instantiate(self.color_code)
			agent.initialize_by_cell_type(Cell.TYPES.ACTIVATEDBCELL, self.color_code, range_of_mutations)
			agent.position = cell.position
			cell.agent_root_node.add_child(agent)
			proliferate_timer = 0
	
func emanate(cell: Cell):
	print_debug("Activated b cell does not emanate.")
	
func should_differenciate(cell: Cell) -> bool:
	var caller_id = cell.get_instance_id()
	cell.fetch_grid_value.emit(cell.position, TileMapController.SUBSTANCE_TYPE.IL5, caller_id)
	var grid_state_value = int(floor(await cell.grid_state_value_response*9))
	
	var random = randf_range(0.0,1.0)
	if(grid_state_value == 0 || grid_state_value == 9):
		if(class_weights[int(grid_state_value)] > random):
			return true
		else:
			return false

	if(class_weights[int(grid_state_value)-1] < random && class_weights[int(grid_state_value)+1] > random):
		return true
	
	return false
	
func deactivate(cell: Cell):
	cell_type = cell.TYPES.BCELL
	super.differenciate(cell, -1)


	
	
	
