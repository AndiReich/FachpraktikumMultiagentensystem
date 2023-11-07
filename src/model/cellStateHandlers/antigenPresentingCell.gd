class_name AntigenPresentingCell extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate():
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate():
	print_debug("Antigen presenting cell does not generate.")
	
func emanate():
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
