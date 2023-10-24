class_name Antigen extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	# moves towards next antibody?
	super.move()
	
func differenciate():
	print_debug("Antigen does not differenciate.")
	
func generate():
	# should antigens reproduce or not?
	print_debug("Antigen does not generate.")
	
func emanate():
	# emanates chemotactic substances
	print("Not implemented yet.")
