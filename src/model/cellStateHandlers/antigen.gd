class_name Antigen extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	
func move(delta: float, cell: Cell):
	# moves towards next antibody?
	super.move(delta,cell)
	
func differenciate():
	print_debug("Antigen does not differenciate.")
	
func generate():
	# should antigens reproduce or not?
	print_debug("Antigen does not generate.")
	
func emanate():
	# emanates chemotactic substances
	print("Not implemented yet.")
