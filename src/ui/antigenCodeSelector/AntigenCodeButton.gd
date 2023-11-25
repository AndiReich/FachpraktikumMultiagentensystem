class_name AntigenCodeButton extends Button

@export var code_position : int

func _toggled(button_pressed):
	if button_pressed:
		text = "1"
		owner.selected_code[code_position] = 1
		owner.recalculate_sprite()
	else:
		text = "0"
		owner.selected_code[code_position] = 0
		owner.recalculate_sprite()
	
