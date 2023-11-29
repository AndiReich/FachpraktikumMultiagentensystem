class_name CellTracker
extends Area2D

var detected_cells: Array = []

func _init():
	pass

func _ready():
	pass

func _on_area_entered(cell):
	detected_cells.append(cell)
	print("Cell entered. Cells inside:", detected_cells)

func _on_area_exited(cell):
	if cell in detected_cells:
		detected_cells.erase(cell)
		print("Cell exited. Cells inside:", detected_cells)
