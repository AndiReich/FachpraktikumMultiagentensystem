class_name Plasmacyte extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	super.move()
	
func differenciate():
	print_debug("Plasmacyte does not differenciate.")
	
# generate or emanate Antibodies randomly when IL6 concentration is high enough
func generate():
	# Andi: I think generate makes the most sense for the Antibodies since we want them to be visible.
	# Also, should an Antibody be a cell or something seperate?
	# print_debug("Plasmacyte does not generate.")
	return
	
func emanate():
	# print_debug("Plasmacyte does not emanate.")
	return
