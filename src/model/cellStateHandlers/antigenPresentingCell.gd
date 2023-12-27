class_name AntigenPresentingCell extends CellStateHandler

const MOVEMENT_TARGETS = [Cell.TYPES.BCELL, Cell.TYPES.THELPERCELL]

const DEACTIVATION_COOLDOWN: float = 30
var deactivation_timer: float = 0


func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ANTIGENPRESENTINGCELL
	var base = Global.macrophage_image
	var overlay = Global.macrophage_overlay
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	var closest_neighbor = super.find_closest_neighbor(cell, neighbors, MOVEMENT_TARGETS)
	move(delta, cell, closest_neighbor)
	
	if(deactivation_timer > DEACTIVATION_COOLDOWN):
		deactivation_timer = 0.0
		deactivate(cell)
	deactivation_timer += delta
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate(cell: Cell):
	print_debug("Antigen presenting cell does not generate.")
	
func emanate(cell: Cell):
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
	
func deactivate(cell: Cell):
	cell_type = cell.TYPES.MACROPHAGE
	super.differenciate(cell, -1)
