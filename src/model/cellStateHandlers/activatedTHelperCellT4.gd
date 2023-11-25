class_name ActivatedTHelperCellT4 extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate(cell : Cell):
	print_debug("Activated t-helper cell T4 does not differenciate.")
	
func generate(cell : Cell):
	# generate new T4 Helper cells randomly when ILs levels are high enough
	print("Not implemented yet.")
	
func emanate(cell : Cell):
	# emanate ILs 2, 4, 5 and 6
	print("Not implemented yet.")
