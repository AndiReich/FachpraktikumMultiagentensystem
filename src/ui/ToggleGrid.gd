class_name ToggleGrid extends CheckButton

@export var substanceType : TileMapController.SUBSTANCE_TYPE

func _on_toggled(button_pressed):
	owner.on_grid_toggle.emit(substanceType)
