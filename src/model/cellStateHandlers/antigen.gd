class_name Antigen extends CellStateHandler

var cell: Cell

func next_move(delta: float, cell: Cell):
	self.cell = cell
	move(delta, cell)
	emanate_timer += delta
	if emanate_timer > emanate_cooldown:
		emanate()
		emanate_timer = 0.0
	
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
	cell.antigen_emanate.emit(cell.global_position, cell.TYPES.ANTIGEN)
