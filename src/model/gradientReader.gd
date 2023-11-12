class_name GradientReader extends Node2D # as singleton


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
	
	gradient_grid = transpose_matrix(gradient_grid)
	print(gradient_grid)

func transpose_matrix(matrix: Array):
	var transposed_matrix = []

	# Get the number of rows and columns in the original matrix
	var rows = matrix.size()
	var columns = matrix[0].size()

	# Initialize the transposed matrix with empty arrays
	for i in range(columns):
		transposed_matrix.append([])

	# Iterate through the original matrix and fill in the transposed matrix
	for i in range(rows):
		for j in range(columns):
			transposed_matrix[j].append(matrix[i][j])

	return transposed_matrix
			
