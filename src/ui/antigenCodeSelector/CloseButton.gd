extends Button

func _pressed():
	owner.close.emit()
