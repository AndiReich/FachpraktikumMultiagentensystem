class_name THelperCellT4 extends CellStateHandler

# imports
var ActivatedTHelperCellT4 = load("res://src/model/cellStateHandlers/activatedTHelperCellT4.gd")

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# should probably move randomly
	super.move()
	
func differenciate():
	# handle collision with antigen presenting cell via signals and then differenciate
	return ActivatedTHelperCellT4.new()
	
func generate():
	print_debug("T4 helper cell does not generate.")
	
func emanate():
	print_debug("T4 helper cell does not emanate.")
