class_name Cell extends Area2D

enum TYPES {MACROPHAGE, PLASMACYTE, THELPERCELL, BCELL, ACTIVATEDBCELL, ANTIGENPRESENTINGCELL, ANTIGEN, ACTIVATEDTHELPERCELL} 

@export var initialCellType: TYPES = TYPES.ANTIGEN
@export var isInitialize: bool = false

var cellStateHandler: CellStateHandler = CellStateHandler.new()


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
	var tileMapController = root.find_child("TileMapController", true, false)
	antigen_emanate.connect(tileMapController._on_virus_antigen_emanate)
	input_event.connect(_on_input_event)
	followMouse()

func _process(delta: float):
	if isInitialize:
		followMouse()
	else:
		next_move(delta)

func followMouse():
	position = get_global_mouse_position()
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)

func next_move(delta: float):
	## this is the only function that should be called for the cellStateHandler
	cellStateHandler.next_move(delta, self)

func set_state(cellStateHandler: CellStateHandler):
	self.cellStateHandler = cellStateHandler


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		isInitialize = false
