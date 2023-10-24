class_name ActivatedBCell extends CellStateHandler

func next_move(cell: Cell):
	# implement
	print("Not implemented yet.")
	
func move():
	super.move()
	
func differenciate():
	# maybe something like each x ticks there is a chance for differenciation to either B cell or P Cell
	if(true):
		return BCell.new()
	else:
		return Plasmacyte.new()
	
func generate():
	# generate new B Cells if a concentration of IL2, IL4 and IL5 is high enough
	return
	
func emanate():
	print_debug("Activated b cell does not emanate.")
