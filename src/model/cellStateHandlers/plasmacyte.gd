class_name Plasmacyte extends CellStateHandler


func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	super.move()
	
func differenciate():
	print_debug("Plasmacyte does not differenciate.")
	
func generate():
	# Andi: I think generate makes more sense for the Antibodies since we want them to be visible
	# Should an Antibody be a cell or something seperate?
	print_debug("Plasmacyte does not generate.")
	
func emanate():
	print_debug("Plasmacyte does not emanate.")
