class_name BCell extends CellStateHandler

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate(cell : Cell):
	# handle collision with antigen presenting cell via signals and then differenciate
	return ActivatedTHelperCellT4.new()
	
func generate(cell : Cell):
	
	print_debug("T4 helper cell does not generate.")
	
func emanate(cell : Cell):
	print_debug("T4 helper cell does not emanate.")
