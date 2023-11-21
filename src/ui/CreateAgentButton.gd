extends TextureButton

@export var agentType : Cell.TYPES

var agentRootNode

func _ready():
	agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)

func _pressed():
	var agent
	match agentType:
		Cell.TYPES.MACROPHAGE: print("")
		
		Cell.TYPES.PLASMACYTE: print("")
		
		Cell.TYPES.THELPERCELL: print("")
		
		Cell.TYPES.BCELL: print("")
		
		Cell.TYPES.ACTIVATEDBCELL: print("")
		
		Cell.TYPES.ANTIGENPRESENTINGCELL: 
			print("APC")
		
		Cell.TYPES.ANTIGEN: agent = preload("res://scenes/agents/virusTest.tscn").instantiate()
		
		Cell.TYPES.ACTIVATEDTHELPERCELL: print("")
	
	if agent:
		agent.isInitialize = true
		agentRootNode.add_child(agent)
	
