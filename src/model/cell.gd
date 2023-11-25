class_name Cell extends Area2D

enum TYPES {MACROPHAGE, PLASMACYTE, THELPERCELL, BCELL, ACTIVATEDBCELL, ANTIGENPRESENTINGCELL, ANTIGEN, ACTIVATEDTHELPERCELL} 

@export var initialCellType: TYPES = TYPES.ANTIGEN

var cellStateHandler: CellStateHandler = CellStateHandler.new()

var agentRootNode

# As I see it there are two different approaches:
# have a unified signal "cell_emanate" and add a cell type argument
#
# or this way where we have multiple handler functions for different signals
# (this way we have more freedom of what data we send on a per celltype basis)

# only scripts that are attached to a node are able to define signals 
signal antigen_emanate(position, type)

func _ready():
	$AnimatedSprite2D.play()
	match initialCellType:
		TYPES.MACROPHAGE: print("")
		
		TYPES.PLASMACYTE: print("")
		
		TYPES.THELPERCELL: print("")
		
		TYPES.BCELL: print("")
		
		TYPES.ACTIVATEDBCELL: print("")
		
		TYPES.ANTIGENPRESENTINGCELL: print("")
		
		TYPES.ANTIGEN: cellStateHandler = Antigen.new()
		
		TYPES.ACTIVATEDTHELPERCELL: print("")
	
	var root = get_tree().root
	agentRootNode = root.find_child("AgentRootNode", true, false)
	var tileMapController = root.find_child("TileMapController", true, false)
	antigen_emanate.connect(tileMapController._on_virus_antigen_emanate)
	set_process_input(false)

func _process(delta: float):
	next_move(delta)

func next_move(delta: float):
	## this is the only function that should be called for the cellStateHandler
	cellStateHandler.next_move(delta, self)

func set_state(cellStateHandler: CellStateHandler):
	self.cellStateHandler = cellStateHandler

func _input_event(viewport, event, shape_idx):
	var simulationUI = get_tree().root.find_child("SimulationUI", true, false)
	if simulationUI.deleteMode and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			queue_free()
