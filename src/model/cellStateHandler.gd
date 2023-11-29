class_name CellStateHandler

@export var random_walk_diffusion_rate: float = 10.0
@export var alpha: float = 1.0 # weight of active movement in total velocity
@export var beta: float = 1.0 # weight of Brownian motion/random walk in total velocity
@export var gamma: float = 0.0 # weight of Chemotaxis movement in total velocity
@export var emanate_cooldown: float = 1.0 # cooldown for emanation
@export var active_move_speed: float = 10.0

var rng = RandomNumberGenerator.new() # TODO: should probably be moved to main scene to have a globale RNG
# set initial value to cooldown to start emanating at the beginning of the 
# simulation
var emanate_timer: float = emanate_cooldown 
var cell_texture: ImageTexture
var color_utils = preload("res://src/utils/color_utils.gd")
var range_of_mutations = 16

func _init():
	rng.randomize()

# modular interface for actions as defined in Ballet 1997 (miro board diagram)
# default implementation should always fail as it is not intended to be instanciated.
func next_move(delta: float, cell: Cell, neighbors: Array):
	move(delta, cell, null)
	
func move(delta: float, cell: Cell, target: Cell):
	# maybe have default move here and have input parameters from child classes
	# e.g. some array or something of movement probabilites
	# implementation for Brownian motion taken from:
	#     https://scipy-cookbook.readthedocs.io/items/BrownianMotion.html
	if target:
		var target_direction = (target.position - cell.position).normalized()
		var target_distance = cell.position.distance_to(target.position)
		var update_active_movement = target_direction * active_move_speed * delta
		cell.position += update_active_movement
	
	var x: float = rng.randfn()
	var y: float = rng.randfn()
	var update_random_walk: Vector2 = beta * random_walk_diffusion_rate**2 * delta * Vector2(x, y).normalized()
	cell.position += update_random_walk
	cell.position = cell.position.clamp(Vector2.ZERO, cell.get_viewport_rect().size)
	
func differenciate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func generate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func emanate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func find_closest_neighbor(cell: Cell, neighbors: Array):
	if !neighbors: 
		return null
		
	var closest_neighbor = null
	var closest_distance = INF 

	for neighbor in neighbors:
		# using length_squared compared to length saves a sqrt
		var distance = (cell.position - neighbor.position).length_squared()

		if distance < closest_distance:
			closest_distance = distance
			closest_neighbor = neighbor

	return closest_neighbor

