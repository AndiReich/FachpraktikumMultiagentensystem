class_name AntigenPresentingCell extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# move towards T4 & B cells
	super.move()
	
func differenciate():
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate():
	print_debug("Antigen presenting cell does not generate.")
	
func emanate():
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
