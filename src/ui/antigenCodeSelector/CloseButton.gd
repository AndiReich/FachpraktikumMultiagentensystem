extends Button

func _pressed():
	owner.close.emit(owner.current_code)
