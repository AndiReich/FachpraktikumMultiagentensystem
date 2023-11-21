extends Label

func _process(delta):
	var nodesCount = get_tree().root.find_child("AgentRootNode", true, false).get_child_count()
	set_text("AgentCount %s" % nodesCount)
