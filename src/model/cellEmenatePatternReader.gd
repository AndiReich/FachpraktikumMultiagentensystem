class_name CellEmenatePatternReader

func read_pattern_for_cell_type(cell_type: String) -> Array:
	var filepath = get_filepath_of_celltype(cell_type)
	if (!FileAccess.file_exists(filepath)):
		return []
	var file = FileAccess.open(filepath, FileAccess.READ)
	var text = file.get_as_text()
	var matrix = get_content_as_2d_Array(text)
	# transposed since we want to address the matrix with [x][y] instead of [y][x]
	var transposed_matrix = transpose_matrix(matrix)
	return transposed_matrix
	
	
func modify_pattern_for_cell_type():
	print_debug("Implement later.")
	
	
func get_content_as_2d_Array(text: String) -> Array:
	var lines = text.strip_edges().split("\n")
	var horizontal_size = lines.size()
	var vertical_size = lines[0].length()
	var gradient_grid = []
	for y_index in vertical_size:
		var characters = lines[y_index].split()
		if(characters.size() > 0):
			gradient_grid.append(characters)
	
	gradient_grid = transpose_matrix(gradient_grid)
	return gradient_grid

func transpose_matrix(matrix: Array) -> Array:
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
		
func get_filepath_of_celltype(cell_type: String) -> String:
	var cell_type_name = str(cell_type).to_lower()
	return "res://resources/%s_gradient.txt" % cell_type_name
	
