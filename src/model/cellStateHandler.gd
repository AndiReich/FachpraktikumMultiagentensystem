class_name CellStateHandler

# modular interface for actions as defined in Ballet 1997 (miro board diagram)
# default implementation should always fail as it is not intended to be instanciated.
func next_move(delta: float, cell: Cell):
	move(delta, cell)

func move(delta: float, cell: Cell):
	# maybe have default move here and have input parameters from child classes
	# e.g. some array or something of movement probabilites
	var velocity = Vector2.ZERO
	velocity.x += 5
	velocity.y += 5
	
	cell.position += velocity * delta
	cell.position = cell.position.clamp(Vector2.ZERO, cell.get_viewport_rect().size)
	
	
func differenciate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func generate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func emanate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	

	

