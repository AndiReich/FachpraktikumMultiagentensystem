class_name ActivatedBCell extends CellStateHandler

var virusScene = preload("res://scenes/agents/virusTest.tscn")

func next_move(delta: float, cell: Cell):
	move(delta, cell)
	# implement
	print("Not implemented yet.")
	
func move(delta: float, cell: Cell):
	super.move(delta,cell)
	
func differenciate(cell : Cell):
	# maybe something like each x ticks there is a chance for differenciation to either B cell or P Cell
	if !should_differenciate():
		return
		
	
func generate(cell : Cell):
	# generate new B Cells if a concentration of IL2, IL4 and IL5 is high enough
	
	if !should_generate():
		return
	
	var newCell = virusScene.instantiate()
	newCell.position = cell.position
	cell.agentRootNode.add_child(newCell)
	
	
func emanate(cell : Cell):
	print_debug("Activated b cell does not emanate.")
	
func should_differenciate() -> bool:
	return true
	
func should_generate() -> bool:
	return true
