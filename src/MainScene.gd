extends Node2D

var agent_scene = preload("res://scenes/agents/agent.tscn")
var range_of_mutations = 16

func _ready():
	var agent_root_node = get_tree().root.find_child("AgentRootNode", true, false)
	for agent_type in Cell.TYPES:
		var num_nodes = randi() % 10 + 1  # Returns random integer between 1 and 10
		
		# Generate nodes
		for i in range(num_nodes):
			var color_code = randi() % 6  # Returns random integer between 0 and 5
			var x = randf() * get_viewport_rect().size.x
			var y = randf() * get_viewport_rect().size.y
			var typ = typeof(agent_type)
			
			var agent = agent_scene.instantiate()
			agent.initialize_by_cell_type(Cell.TYPES[agent_type], color_code, range_of_mutations)
			agent.position.x = x
			agent.position.y = y
			
			agent_root_node.add_child(agent)
