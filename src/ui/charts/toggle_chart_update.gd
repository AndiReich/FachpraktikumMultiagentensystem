class_name ToggleChartUpdate extends CheckButton


var chart_controller_node

func _ready():
	chart_controller_node = get_parent()
	

func _on_toggled(button_pressed):
	chart_controller_node.should_pause = !chart_controller_node.should_pause
