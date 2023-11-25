extends TextureButton

var agentRootNode

func _ready():
	agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)
	
func _pressed():
	var childs = agentRootNode.get_children()
	
	for child in childs:
		child.queue_free()
