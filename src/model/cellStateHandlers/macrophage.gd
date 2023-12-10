class_name Macrophage extends CellStateHandler

const DIFFERENCIATION_TRIGGER = Cell.TYPES.PATHOGEN
const DIFFERENCIATION_TARGET = Cell.TYPES.ANTIGENPRESENTINGCELL
const MOVEMENT_TARGETS = [Cell.TYPES.PATHOGEN]

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
	cell_type = Cell.TYPES.MACROPHAGE
	var base = Image.load_from_file("res://assets/cells/Macrophage.png")
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

func move(delta: float, cell: Cell, target: Cell):
	_grid_movement(delta, cell)
	super.move(delta, cell, target)
	
func differenciate(cell: Cell, color_code: int):
	cell_type = DIFFERENCIATION_TARGET
	super.differenciate(cell, color_code)
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate(cell: Cell):
	print_debug("Macrophage does not emanate.")
	
func _grid_movement(delta: float, cell: Cell):
	# grid movement	
	# we get a  return value form the signal handler in the movement map
	# in this case godot opperates on a single thread so there should be no race condition here
	var caller_id = cell.get_instance_id()
	cell.fetch_grid_state.emit(cell.position, 3, TileMapController.SUBSTANCE_TYPE.CS, caller_id)
	
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
	var update_active_movement = gamma * (target_direction * active_move_speed * delta)
	cell.position += update_active_movement
	return 0.0
