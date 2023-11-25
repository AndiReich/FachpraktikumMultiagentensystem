class_name AntigenPresentingCell extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate(cell : Cell):
	print_debug("Antigen presenting cell does not differenciate.")
	
func generate(cell : Cell):
	print_debug("Antigen presenting cell does not generate.")
	
func emanate(cell : Cell):
	# APC does not emanate
	print_debug("Antigen presenting cell does not emanate.")
