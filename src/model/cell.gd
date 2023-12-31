class_name Cell extends Area2D

enum TYPES {MACROPHAGE, PLASMACYTE, THELPERCELL, BCELL, ACTIVATEDBCELL, ANTIGENPRESENTINGCELL, PATHOGEN, ACTIVATEDTHELPERCELL, ANTIBODY} 

var initial_cell_type: TYPES = TYPES.PATHOGEN
var agent_root_node: Node
var cell_state_handler: CellStateHandler = CellStateHandler.new()

# only scripts that are attached to a node are able to define signals 
signal emanate(position, substance_type)

signal fetch_grid_state(
	cell_position : Vector2, 
	radius: int,
	substance_type: TileMapController.SUBSTANCE_TYPE,
	caller_id: int) 
signal fetch_grid_value(
	cell_position : Vector2, 
	substance_type: TileMapController.SUBSTANCE_TYPE,
	caller_id: int) 
	
signal grid_state_response(movement_map: Dictionary)
signal grid_state_value_response(value: float)

func _ready():
	var root = get_tree().root
	agent_root_node = root.find_child("AgentRootNode", true, false)
	var tilemap_controller = root.find_child("TileMapController", true, false)
	emanate.connect(tilemap_controller._on_emanate)
	fetch_grid_state.connect(tilemap_controller._on_fetch_grid_state)
	fetch_grid_value.connect(tilemap_controller._on_fetch_grid_value)

func initialize_by_cell_type(cell_type: TYPES, color_code: int, range_of_mutations: int):
	# This basically acts like a constructor for the node
	# the reason why we are doing it like this is so that we can easily
	# create new agents in the scene with little effort
	initial_cell_type = cell_type
	match initial_cell_type:
		TYPES.MACROPHAGE: 
			cell_state_handler = Macrophage.new()
		
		TYPES.PLASMACYTE: 
			cell_state_handler = Plasmacyte.new(color_code)
		
		TYPES.THELPERCELL: 
			cell_state_handler = THelperCellT4.new()
		
		TYPES.BCELL: 
			cell_state_handler = BCell.new()
		
		TYPES.ACTIVATEDBCELL: 
			cell_state_handler = ActivatedBCell.new(color_code)
		
		TYPES.ANTIGENPRESENTINGCELL: 
			cell_state_handler = AntigenPresentingCell.new(color_code)
		
		TYPES.PATHOGEN: 
			cell_state_handler = Pathogen.new(color_code)
		
		TYPES.ACTIVATEDTHELPERCELL: 
			cell_state_handler = ActivatedTHelperCellT4.new(color_code)
			
		TYPES.ANTIBODY:
			cell_state_handler = Antibody.new(color_code)
	
	cell_state_handler.direct_movement_weight = Global.initial_direct_motion
	cell_state_handler.brownian_movement_weight = Global.initial_brownian_motion
	cell_state_handler.il_movement_weight = Global.initial_il_motion
	
	get_child(0).texture = cell_state_handler.cell_texture
	

func _process(delta: float):
	## this is the only function that should be called for the cell_state_handler
	if initial_cell_type != null:
		cell_state_handler.next_move(delta, self, $CellTracker.detected_cells, $CellCollider.detected_cells)

func set_state(cell_state_handler: CellStateHandler):
	self.cell_state_handler = cell_state_handler
	$Sprite2D.texture = cell_state_handler.cell_texture

func _input_event(viewport, event, shape_idx):
	var simulationUI = get_tree().root.find_child("SimulationUI", true, false)
	if simulationUI.deleteMode and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			queue_free()
