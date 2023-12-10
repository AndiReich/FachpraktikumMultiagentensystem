extends Node2D

var agent_scene = preload("res://scenes/agents/agent.tscn")
var range_of_mutations = 16
var agent_root_node

func _ready():
	agent_root_node = get_tree().root.find_child("AgentRootNode", true, false)
	
	var map = {
		Cell.TYPES.MACROPHAGE: Global.initial_macrophage_count,
		Cell.TYPES.PLASMACYTE: Global.initial_p_cell_count, 
		Cell.TYPES.THELPERCELL: Global.initial_t_cell_count, 
		Cell.TYPES.BCELL: Global.initial_b_cell_count, 
		Cell.TYPES.ACTIVATEDBCELL: Global.initial_act_b_cell_count, 
		Cell.TYPES.ANTIGENPRESENTINGCELL: Global.initial_apc_count, 
		Cell.TYPES.PATHOGEN: Global.initial_virus_count, 
		Cell.TYPES.ACTIVATEDTHELPERCELL: Global.initial_act_t_cell_count, 
		Cell.TYPES.ANTIBODY: Global.initial_antibody_count,
	}
	
	for element in map.keys():
		generate_nodes_by_type(map[element], Global.color_code, element)
	
func generate_nodes_by_type(number: int, color_code: int, agent_type: int):
		# Generate nodes
		for i in number:
			var x = randf() * get_viewport_rect().size.x
			var y = randf() * get_viewport_rect().size.y
			var typ = typeof(agent_type)
			
			var agent = agent_scene.instantiate()
			agent.initialize_by_cell_type(agent_type, color_code, range_of_mutations)
			agent.position.x = x
			agent.position.y = y
			
			agent_root_node.add_child(agent)
