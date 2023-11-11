class_name Cell extends Area2D

enum TYPES {MACROPHAGE, PLASMACYTE, THELPERCELL, BCELL, ACTIVATEDBCELL, ANTIGENPRESENTINGCELL, ANTIGEN, ACTIVATEDTHELPERCELL} 

@export var initialCellType: TYPES = TYPES.ANTIGEN

var cellStateHandler: CellStateHandler = CellStateHandler.new()


# As I see it there are two different approaches:
# have a unified signal "cell_emanate" and add a cell type argument
#
# or this way where we have multiple handler functions for different signals
# (this way we have more freedom of what data we sendon a per celltype basis)

# only scripts that are attached to a node are able to define signals 
signal antigen_emanate(pos_x, pos_y, value)

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

func _process(delta: float):
	next_move(delta)


func next_move(delta: float):
	## this is the only function that should be called for the cellStateHandler
	cellStateHandler.next_move(delta, self)

func set_state(cellStateHandler: CellStateHandler):
	self.cellStateHandler = cellStateHandler
