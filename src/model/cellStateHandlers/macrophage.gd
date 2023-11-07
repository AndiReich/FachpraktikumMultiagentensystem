class_name Macrophage extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	# should move towards antigen
	super.move(delta,cell)
	
func differenciate():
	# handle collision with antigen via signals and then differenciate
	return AntigenPresentingCell.new()
	
func generate():
	print_debug("Macrophage does not generate.")
	
func emanate():
	print_debug("Macrophage does not emanate.")
