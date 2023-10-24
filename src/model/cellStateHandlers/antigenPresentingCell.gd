class_name AntigenPresentingCell extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# move towards T4 & B cells
	super.move()
	
func differenciate():
	# APC does not differenciate
	return 
	
func generate():
	# APC does not generate
	print("Not implemented yet.")
	
func emanate():
	# APC does not emanate
	print("Not implemented yet.")
