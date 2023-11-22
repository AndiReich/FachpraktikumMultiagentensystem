extends TextureButton

@export var agentType : Cell.TYPES

var agentRootNode
var simulationUINode

func _ready():
	agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)
	simulationUINode = get_tree().root.find_child("SimulationUI", true, false)

func _pressed():
	var agent
	match agentType:
		Cell.TYPES.MACROPHAGE: print("")
		
		Cell.TYPES.PLASMACYTE: print("")
		
		Cell.TYPES.THELPERCELL: print("")
		
		Cell.TYPES.BCELL: print("")
		
		Cell.TYPES.ACTIVATEDBCELL: print("")
		
		Cell.TYPES.ANTIGENPRESENTINGCELL: 
			var codeSelection = simulationUINode.find_child("antigen_code_selector", true, false)
			if !codeSelection:
				codeSelection = preload("res://scenes/ui/antigen_code_selector.tscn").instantiate()
				simulationUINode.add_child(codeSelection)
				await codeSelection.close
				var selectedCode = codeSelection.selectedCode
				simulationUINode.remove_child(codeSelection)
				codeSelection.queue_free()
				print("APC")
		
		Cell.TYPES.ANTIGEN: agent = preload("res://scenes/agents/virusTest.tscn").instantiate()
		
		Cell.TYPES.ACTIVATEDTHELPERCELL: print("")
	
	if agent:
		agent.isInitialize = true
		agentRootNode.add_child(agent)
	
