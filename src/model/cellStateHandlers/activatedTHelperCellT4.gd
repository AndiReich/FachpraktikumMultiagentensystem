class_name ActivatedTHelperCellT4 extends CellStateHandler

const MOVEMENT_TARGETS = []

const DEACTIVATION_COOLDOWN: float = 30
var deactivation_timer: float = 0

func _init(color_code: int):
	self.color_code = color_code
	cell_type = Cell.TYPES.ACTIVATEDTHELPERCELL
	var base = Image.load_from_file("res://assets/cells/THelperCell.png")
	var overlay = Image.load_from_file("res://assets/cells/THelperCellOverlay.png")
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
	
func move(delta: float, cell: Cell, target: Cell):
	grid_movement_towards_substance(delta, cell, TileMapController.SUBSTANCE_TYPE.IL2)
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Activated t-helper cell T4 does not differenciate.")
	
func generate():
	# generate new T4 Helper cells randomly when ILs levels are high enough
	pass
	
func emanate(cell: Cell):
	# emanate ILs 2, 4, 5 and 6
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL2)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL4)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL5)
	cell.emanate.emit(cell.global_position, TileMapController.SUBSTANCE_TYPE.IL6)
	
func deactivate(cell: Cell):
	cell_type = cell.TYPES.THELPERCELL
	super.differenciate(cell, -1)
