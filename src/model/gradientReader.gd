class_name GradientReader extends Node2D


@export var filepath: String

var gradient_grid = []

func _ready():
	var file = FileAccess.open(filepath, FileAccess.READ)
	var text = file.get_as_text()
	getContentAs2dArray(text)
	
	
func getContentAs2dArray(text: String):
	var lines = text.strip_edges().split("\n")
	var horizontal_size = lines.size()
	var vertical_size = lines[0].length()
	for y_index in vertical_size:
		var characters = lines[y_index].split()
		if(characters.size() > 0):
			gradient_grid.append(characters)
