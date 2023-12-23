class_name ActivatedTHelperCellT4 extends CellStateHandler

var agent_scene = preload("res://scenes/agents/agent.tscn")

const MOVEMENT_TARGETS = []
const DEACTIVATION_COOLDOWN: float = 60
const GRID_MOVEMENT_COOLDOWN = 0.5
const PROLIFERATE_NEIGHBORS_LIMIT: int = 3
const PROLIFERATE_COLLDOWN: float = 10
const IL2_TRESHHOLD : float = 0.75

var IL2 = TileMapController.SUBSTANCE_TYPE.IL2
var grid_movement_timer: float = 0
var deactivation_timer: float = 0
var proliferate_timer: float = 0

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ACTIVATEDTHELPERCELL
	var base = Global.t_helper_cell_image
	var overlay = Global.t_helper_cell_overlay
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate(cell)
		emanate_timer = 0.0

	if(deactivation_timer > DEACTIVATION_COOLDOWN):
		deactivation_timer = 0.0
		deactivate(cell)
	deactivation_timer += delta
	
	var act_t_cell_neighbors = neighbors.filter(filter_is_t_cell)
	if act_t_cell_neighbors.size() < PROLIFERATE_NEIGHBORS_LIMIT:
		generate(cell)
	proliferate_timer += delta

func filter_is_t_cell(cell: Cell):
	return (cell.cell_state_handler.cell_type == Cell.TYPES.ACTIVATEDTHELPERCELL 
	|| cell.cell_state_handler.cell_type == Cell.TYPES.THELPERCELL)

func move(delta: float, cell: Cell, target: Cell):
	if(grid_movement_timer > GRID_MOVEMENT_COOLDOWN):
		super.grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL2)
		grid_movement_timer = 0
	grid_movement_timer += delta

	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Activated t-helper cell T4 does not differenciate.")
	
func generate(cell: Cell):
	if proliferate_timer >= PROLIFERATE_COLLDOWN:
		var caller_id = cell.get_instance_id()
		cell.fetch_grid_value.emit(cell.position, IL2, caller_id)
		var il2_value = await cell.grid_state_value_response
		if il2_value >= IL2_TRESHHOLD:
			var agent = agent_scene.instantiate(self.color_code)
			agent.initialize_by_cell_type(Cell.TYPES.ACTIVATEDBCELL, self.color_code, range_of_mutations)
			agent.position = cell.position
			cell.agent_root_node.add_child(agent)
			proliferate_timer = 0
		
func emanate(cell: Cell):
	# emanate ILs 2, 4, 5 and 6
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL2)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL4)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL5)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL6)

func deactivate(cell: Cell):
	cell_type = cell.TYPES.THELPERCELL
	super.differenciate(cell, -1)
