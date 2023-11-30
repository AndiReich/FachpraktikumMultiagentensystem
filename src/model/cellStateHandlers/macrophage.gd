class_name Macrophage extends CellStateHandler

const DIFFERENCIATION_TRIGGER = Cell.TYPES.PATHOGEN
const DIFFERENCIATION_TARGET = Cell.TYPES.ANTIGENPRESENTINGCELL

func _init():
	cell_type = Cell.TYPES.MACROPHAGE
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

# macrophage moves towards closet pathogen
func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, Cell.TYPES.PATHOGEN)
	move(delta, cell, closest_neighbor)
	var colliding_cell = find_colliding_cell(cell, collisions, DIFFERENCIATION_TRIGGER)
	if colliding_cell:
		var color_code = colliding_cell.cell_state_handler.color_code
		differenciate(cell, color_code)
		colliding_cell.call_deferred("queue_free")

func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	# handle collision with antigen via signals and then differenciate
	# TODO: Change once its done
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate(cell: Cell):
	print_debug("Macrophage does not emanate.")
