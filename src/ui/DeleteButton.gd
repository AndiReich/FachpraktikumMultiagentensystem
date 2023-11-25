extends TextureButton

func _pressed():
	owner.deleteMode.emit()
