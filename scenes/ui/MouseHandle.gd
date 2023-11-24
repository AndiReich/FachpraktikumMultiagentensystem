extends Container

var antibodySprite = preload("res://assets/cells/Antigen.png")
var apcSprite = preload("res://assets/cells/APCMacrophage.png")
var bCellSprite = preload("res://assets/cells/BCell.png")
var macrophageSprite = preload("res://assets/cells/Macrophage.png")
var plasmaCellSprite = preload("res://assets/cells/PlasmaCell.png")
var tHelperSprite = preload("res://assets/cells/THelperCell.png")
var virusSprite = preload("res://assets/cells/virusGreen0.png")

var antibodyScene
var apcScene
var bCellScene
var macrophageScene
var plasmaCellScene
var tHelperScene
var virusScene = preload("res://scenes/agents/virusTest.tscn")
var codeSelectionScene = preload("res://scenes/ui/antigen_code_selector.tscn")

var agentRootNode
var simulationUINode

var selectedAgentType

# Called when the node enters the scene tree for the first time.
func _ready():
#	size = get_viewport().size
	agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)
	simulationUINode = get_tree().root.find_child("SimulationUI", true, false)

#func _input(event):
#	print(event)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var agent
			match selectedAgentType:
				Cell.TYPES.MACROPHAGE:
					agent = macrophageScene.instantiate()
				
				Cell.TYPES.PLASMACYTE:
					agent = plasmaCellScene.instantiate()
				
				Cell.TYPES.THELPERCELL:
					agent = tHelperScene.instantiate()
				
				Cell.TYPES.BCELL:
					agent = bCellScene.instantiate()
				
				Cell.TYPES.ACTIVATEDBCELL:
					agent = bCellScene.instantiate()
				
				Cell.TYPES.ANTIGENPRESENTINGCELL:
					agent = apcScene.instantiate()
				
				Cell.TYPES.ANTIGEN: 
					agent = virusScene.instantiate()
				
				Cell.TYPES.ACTIVATEDTHELPERCELL:
					agent = tHelperScene.instantiate()
			
			if agent:
				var mouse_position = get_global_mouse_position()
				agentRootNode.add_child(agent)
				agent.position = mouse_position
				
#	if event is InputEventKey:
#		print("key")
#		if event.keycode == KEY_ESCAPE and event.pressed:
#			print("esc")
#			selectedAgentType = null
#			Input.set_default_cursor_shape()
	
func _on_agents_instantiate_agent(agentType):
	selectedAgentType = agentType
	match selectedAgentType:
		Cell.TYPES.MACROPHAGE:
			Input.set_custom_mouse_cursor(macrophageSprite)
		
		Cell.TYPES.PLASMACYTE:
			var code = await select_antigen_code()			
			Input.set_custom_mouse_cursor(plasmaCellSprite)
		
		Cell.TYPES.THELPERCELL:
			Input.set_custom_mouse_cursor(tHelperSprite)
		
		Cell.TYPES.BCELL:
			Input.set_custom_mouse_cursor(bCellSprite)
		
		Cell.TYPES.ACTIVATEDBCELL:
			var code = await select_antigen_code()
			Input.set_custom_mouse_cursor(bCellSprite)
		
		Cell.TYPES.ANTIGENPRESENTINGCELL:
			var code = await select_antigen_code()
			Input.set_custom_mouse_cursor(apcSprite)
		
		Cell.TYPES.ANTIGEN: 
			var code = await select_antigen_code()
			Input.set_custom_mouse_cursor(virusSprite)
		
		Cell.TYPES.ACTIVATEDTHELPERCELL:
			var code = await select_antigen_code()
			Input.set_custom_mouse_cursor(tHelperSprite)

func select_antigen_code():
	var codeSelection = simulationUINode.find_child("antigen_code_selector", true, false)
	
	codeSelection.show()
	
	await codeSelection.close
	var selectedCode = codeSelection.selectedCode
	
	codeSelection.hide()
	
	return selectedCode
