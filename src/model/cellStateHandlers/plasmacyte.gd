class_name Plasmacyte extends CellStateHandler

var agent_scene = preload("res://scenes/agents/agent.tscn")

var cell_type: Cell.TYPES = Cell.TYPES.PLASMACYTE
var generate_cooldown: float = 1.0
var generate_timer: float = generate_cooldown
var antigen_code: int

func _init(color_code: int):
	antigen_code = color_code
	cell_type = Cell.TYPES.PLASMACYTE
	var base = Image.load_from_file("res://assets/cells/Plasmacyte.png")
	var overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
	var modified_image = color_utils.get_specific_permutation_with_overlay(base, overlay, range_of_mutations, color_code)
	var resulting_texture = ImageTexture.create_from_image(modified_image)
	cell_texture = resulting_texture

func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	generate_timer += delta
	if generate_timer > generate_cooldown:
		try_generate(cell)
		generate_timer = 0.0
	move(delta, cell, null)
	
func move(delta: float, cell: Cell, target: Cell):
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	print_debug("Plasmacyte does not differenciate.")
	
func try_generate(cell: Cell):
	# 1. check IL6 value on grid
	# 2. produce antibody of specific type
	var antibody = agent_scene.instantiate()
	antibody.initialize_by_cell_type(Cell.TYPES.ANTIBODY, antigen_code, range_of_mutations)
	antibody.position = cell.position
	cell.agent_root_node.add_child(antibody)
	
func emanate():
	# print_debug("Plasmacyte does not emanate.")
	return
