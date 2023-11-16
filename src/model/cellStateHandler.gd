class_name CellStateHandler

@export var random_walk_diffusion_rate: float = 10.0
@export var alpha = 0.0 # weight of active movement in total velocity
@export var beta = 1.0 # weight of Brownian motion/random walk in total velocity
@export var gamma = 0.0 # weight of Chemotaxis movement in total velocity

var rng = RandomNumberGenerator.new() # TODO: should probably be moved to main scene to have a globale RNG

func _init():
	rng.randomize()

# modular interface for actions as defined in Ballet 1997 (miro board diagram)
# default implementation should always fail as it is not intended to be instanciated.
func next_move(delta: float, cell: Cell):
	move(delta, cell)

func move(delta: float, cell: Cell):
	# maybe have default move here and have input parameters from child classes
	# e.g. some array or something of movement probabilites
  
	# implementation for Brownian motion taken from:
	#     https://scipy-cookbook.readthedocs.io/items/BrownianMotion.html
	var x: float = rng.randfn()
	var y: float = rng.randfn()
	var update_random_walk: Vector2 = random_walk_diffusion_rate**2 * delta * Vector2(x, y).normalized()
	var update_total: Vector2 = beta * update_random_walk 
	cell.position += update_total
	cell.position = cell.position.clamp(Vector2.ZERO, cell.get_viewport_rect().size)
	
func differenciate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func generate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func emanate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	

	

