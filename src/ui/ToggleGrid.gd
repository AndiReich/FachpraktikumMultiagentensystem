class_name ToggleGrid extends CheckButton

@export var substanceType : TileMapController.SUBSTANCE_TYPE

var simulationUINode

func _ready():
	simulationUINode = get_tree().root.find_child("SimulationUI", true, false)
	

func _on_toggled(button_pressed):
	simulationUINode.on_grid_toggle.emit(substanceType)
