class_name Macrophage extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# should move towards Antigens
	super.move()
	
func differenciate():
	# handle collision with antigen via signals and then differenciate
	return AntigenPresentingCell.new()
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate():
	print_debug("Macrophage does not emanate.")
