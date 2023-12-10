class_name CellStateHandler

@export var random_walk_diffusion_rate: float = 10.0
@export var alpha: float = 1.0 # weight of active movement in total velocity
@export var beta: float = 1.0 # weight of Brownian motion/random walk in total velocity
@export var gamma: float = 1.0 # weight of Chemotaxis movement in total velocity
@export var emanate_cooldown: float = 1.0 # cooldown for emanation
@export var active_move_speed: float = 10.0

var rng = RandomNumberGenerator.new() # TODO: should probably be moved to main scene to have a globale RNG
# set initial value to cooldown to start emanating at the beginning of the 
# simulation
var emanate_timer: float = emanate_cooldown 
var cell_texture: ImageTexture
var color_utils = preload("res://src/utils/color_utils.gd")
var range_of_mutations = 16
var antigen_code_bitlength = 4
var color_code = -1
var cell_type = null

func _init():
	rng.randomize()

# modular interface for actions as defined in Ballet 1997 (miro board diagram)
# default implementation should always fail as it is not intended to be instanciated.
func next_move(delta: float, cell: Cell, neighbors: Array, collisions: Array):
	move(delta, cell, null)
	
func move(delta: float, cell: Cell, target: Cell):
	# maybe have default move here and have input parameters from child classes
	# e.g. some array or something of movement probabilites
	# implementation for Brownian motion taken from:
	#     https://scipy-cookbook.readthedocs.io/items/BrownianMotion.html
	
	# active movement 
	if target:
		var target_direction = (target.position - cell.position).normalized()
		var update_active_movement = alpha * (target_direction * active_move_speed * delta)
		cell.position += update_active_movement
	# brownian motion
	var x: float = rng.randfn()
	var y: float = rng.randfn()
	var update_random_walk: Vector2 = beta * random_walk_diffusion_rate**2 * delta * Vector2(x, y).normalized()
	cell.position += update_random_walk
	cell.position = cell.position.clamp(Vector2.ZERO, cell.get_viewport_rect().size)

func disable_movement():
	self.alpha = 0.0
	self.beta = 0.0
	self.gamma = 0.0
	
func differenciate(cell: Cell, color_code: int):
		cell.initialize_by_cell_type(cell.cell_state_handler.cell_type, color_code, range_of_mutations)
	
func generate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func emanate(cell: Cell):
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")

func find_closest_neighbor(cell: Cell, neighbors: Array, target_cell_types: Array) -> Cell:
	if !neighbors or !target_cell_types: 
		return null
		
	var closest_neighbor = null
	var closest_distance = INF 

	for neighbor in neighbors:
		if neighbor.owner != cell.owner:
			continue
		
		if neighbor.cell_state_handler.cell_type not in target_cell_types:
			continue

		# using length_squared compared to length saves a sqrt
		var distance = (cell.position - neighbor.position).length_squared()

		if distance < closest_distance:
			closest_distance = distance
			closest_neighbor = neighbor

	return closest_neighbor
	
func find_colliding_cell(cell: Cell, collisions: Array, target_cell_type: Cell.TYPES) -> Cell:
	if !collisions or !target_cell_type: 
		return null
	for coliding_cell in collisions:
		if coliding_cell.owner != cell.owner:
			continue
		if coliding_cell.cell_state_handler.cell_type == target_cell_type:
			return coliding_cell
	return null
	
func update_cell_sprite(cell: Cell):
	cell.initialize_by_cell_type(self.cell_type, color_code, range_of_mutations)
