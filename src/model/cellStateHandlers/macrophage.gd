class_name Macrophage extends CellStateHandler

var cell_type: Cell.TYPES = Cell.TYPES.MACROPHAGE

func _init():
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
	var resulting_texture = ImageTexture.create_from_image(base)
	cell_texture = resulting_texture

# macrophage moves towards closet pathogen
func next_move(delta: float, cell: Cell, neighbors: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, Cell.TYPES.PATHOGEN)
	move(delta, cell, closest_neighbor)

func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate():
	# handle collision with antigen via signals and then differenciate
	# TODO: Change once its done
	return AntigenPresentingCell.new(12)
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate():
	print_debug("Macrophage does not emanate.")
