class_name Macrophage extends CellStateHandler
# imports
var AntigenPresentingCell = load("res://src/model/cellStateHandlers/antigenPresentingCell.gd")

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# should move either towards a T4 helper cell or a B cell
	super.move()
	
func differenciate():
	# handle collision with antigen via signals and then differenciate
	return AntigenPresentingCell.new()
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate():
	print_debug("Macrophage does not emanate.")
