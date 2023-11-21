extends TextureButton

@export var agentType : Cell.TYPES

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	var virus = preload("res://scenes/agents/virusTest.tscn").instantiate()
	var agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)
	virus.isInitialize = true
	agentRootNode.add_child(virus)
	
