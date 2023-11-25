class_name Plasmacyte extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate(cell : Cell):
	print_debug("Plasmacyte does not differenciate.")
	
# generate or emanate Antibodies randomly when IL6 concentration is high enough
func generate(cell : Cell):
	# Andi: I think generate makes the most sense for the Antibodies since we want them to be visible.
	# Also, should an Antibody be a cell or something seperate?
	# print_debug("Plasmacyte does not generate.")
	return
	
func emanate(cell : Cell):
	# print_debug("Plasmacyte does not emanate.")
	return
