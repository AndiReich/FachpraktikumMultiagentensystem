extends Button

@export var codePosition : int

func _toggled(button_pressed):
	if button_pressed:
		text = "1"
		owner.selectedCode[codePosition] = 1
	else:
		text = "0"
		owner.selectedCode[codePosition] = 0
