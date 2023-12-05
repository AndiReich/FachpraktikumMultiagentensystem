class_name CellEmenatePatternReader

const utils = preload("res://src/utils/matrix_utils.gd")


func read_pattern_for_cell_type(cell_type: String) -> Array:
	var filepath = get_filepath_of_celltype(cell_type)
	if (!FileAccess.file_exists(filepath)):
		return []
	var file = FileAccess.open(filepath, FileAccess.READ)
	var text = file.get_as_text()
	var matrix = get_content_as_2d_Array(text)
	
	return matrix
	
	
func modify_pattern_for_cell_type():
	print_debug("Implement later.")
	
	
func get_content_as_2d_Array(text: String) -> Array:
	var lines = text.strip_edges().split("\n")
	var vertical_size = lines.size()
	var gradient_grid = []
	for y_index in vertical_size:
		var characters = lines[y_index].split()
		if(characters.size() > 0):
			gradient_grid.append(characters)
	
	utils.transpose_matrix_in_place(gradient_grid)
	return gradient_grid


func get_filepath_of_celltype(cell_type: String) -> String:
	var cell_type_name = str(cell_type).to_lower()
	return "res://resources/%s_gradient.txt" % cell_type_name
