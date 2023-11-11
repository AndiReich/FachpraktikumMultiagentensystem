class_name Antigen extends CellStateHandler


var cell: Cell


func next_move(delta: float, cell: Cell):
	self.cell = cell
	move(delta, cell)
	emanate()
	
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
	cell.antigen_emanate.emit(cell.global_position.x, cell.global_position.y, 4)
	# print("Not implemented yet.")
