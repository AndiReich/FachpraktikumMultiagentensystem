extends CheckBox

@export var tabContainer : TabContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _toggled(button_pressed):
	tabContainer.visible = !tabContainer.visible 
