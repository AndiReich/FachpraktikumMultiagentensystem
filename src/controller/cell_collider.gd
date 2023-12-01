class_name CellCollider extends Area2D

var detected_cells: Array = []

func _init():
	pass

func _ready():
	pass

func _on_area_entered(cell):
	if cell != owner:
		detected_cells.append(cell)

func _on_area_exited(cell):
	if cell in detected_cells:
		detected_cells.erase(cell)
