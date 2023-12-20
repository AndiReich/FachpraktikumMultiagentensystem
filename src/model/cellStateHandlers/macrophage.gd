class_name Macrophage extends CellStateHandler

const DIFFERENCIATION_TRIGGER = Cell.TYPES.PATHOGEN
const DIFFERENCIATION_TARGET = Cell.TYPES.ANTIGENPRESENTINGCELL
const MOVEMENT_TARGETS = [Cell.TYPES.PATHOGEN]

const GRID_MOVEMENT_COOLDOWN = 0.5
var grid_movement_timer = 0



func _init():
	color_code = -1
	cell_type = Cell.TYPES.MACROPHAGE
	var base = Global.macrophage_image
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

# macrophage moves towards closet pathogen
func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
	var colliding_cell = find_colliding_cell(cell, collisions, DIFFERENCIATION_TRIGGER)
	if colliding_cell:
		var color_code = colliding_cell.cell_state_handler.color_code
		differenciate(cell, color_code)
		colliding_cell.call_deferred("queue_free")
		colliding_cell.cell_state_handler.call_deferred("remove_attached_antibodies")

func move(delta: float, cell: Cell, target: Cell):#
	if(grid_movement_timer > GRID_MOVEMENT_COOLDOWN):
		super.grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.CS)
		grid_movement_timer = 0
	grid_movement_timer += delta
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate(cell: Cell):
	print_debug("Macrophage does not emanate.")
	

