class_name CellStateHandler

@export var random_walk_diffusion_rate: float = 10.0
@export var direct_movement_weight: float # weight of active movement in total velocity
@export var brownian_movement_weight: float # weight of Brownian motion/random walk in total velocity
@export var il_movement_weight: float # weight of Chemotaxis movement in total velocity
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

const class_weights = {
	0 : 0.0,
	1 : 0.0029296875,
	2 : 0.0048828125,
	3 : 0.0078125,
	4 : 0.015625,
	5 : 0.03125,
	6 : 0.0625,
	7 : 0.125,
	8 : 0.25,
	9 : 0.50
}

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
		var update_active_movement = direct_movement_weight * (target_direction * active_move_speed * delta)
		cell.position += update_active_movement
	# brownian motion
	var x: float = rng.randfn()
	var y: float = rng.randfn()
	var update_random_walk: Vector2 = brownian_movement_weight * random_walk_diffusion_rate**2 * delta * Vector2(x, y).normalized()
	cell.position += update_random_walk
	cell.position = cell.position.clamp(Vector2.ZERO, cell.get_viewport_rect().size)

func disable_movement():
	self.direct_movement_weight = 0.0
	self.brownian_movement_weight = 0.0
	self.il_movement_weight = 0.0
	
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
	
func grid_movement_towards_substance(delta: float, cell: Cell, substance_type: TileMapController.SUBSTANCE_TYPE):
	# grid movement	
	# we get a return value form the signal handler in the movement map
	# in this case godot opperates on a single thread so there should be no race condition here	
	var caller_id = cell.get_instance_id()
	cell.fetch_grid_state.emit(cell.position, 3, substance_type, caller_id)
	
	var movement_map = await cell.grid_state_response
	var class_counts = {}
	
	for key in movement_map.keys():
		var class_identifier = movement_map[key]
		# print("key %s value %s" % [key, class_identifier])
		
		if(class_counts.has(class_identifier)):
			class_counts[class_identifier] += 1
		else:
			class_counts[class_identifier] = 1
		
	var probability_remainder = 0.0
	for key in class_weights.keys():
		var has_key = class_counts.has(int(key))
		if(has_key == false):
			probability_remainder += class_weights[key]
	
	var resulting_position_probabilities = {}
	for key in movement_map.keys():
		var class_identifier = int(movement_map[key]) 
		var probability_of_class = class_weights[class_identifier]
		var class_count = class_counts[class_identifier]
		if(probability_of_class == 0.0):
			continue
		var probability_used = (1 - probability_remainder)
		var proportional_probability = (probability_of_class / probability_used) * probability_remainder
		
		var probability_value = (probability_of_class + proportional_probability) / class_count
		resulting_position_probabilities[key] = probability_value
		
	# generiere float von 0-1
	# teile das ergebniss der jeweiligen Zelle / 100
	# füge die range irgendwo hinzu? 
	# position = position + velocity * gamma
	var random = randf()
	var cumulative_probability = 0.0
	var resulting_map_position
	for key in resulting_position_probabilities:
		cumulative_probability += resulting_position_probabilities[key]
		if(random <= cumulative_probability):
			resulting_map_position = key
			break
	if(resulting_map_position == null):
		return 0.0 

	var target_direction = ((resulting_map_position - Vector2(8,8)) - cell.position).normalized()
	var update_active_movement = il_movement_weight * (target_direction * active_move_speed * delta)
	cell.position += update_active_movement
	return 0.0
