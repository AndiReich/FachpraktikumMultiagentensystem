class_name CellStateHandler

#imports
var Cell = load("res://src/model/cell.gd")

# modular interface for actions as defined in Ballet 1997 (miro board diagram)
# default implementation should always fail as it is not intended to be instanciated.
func next_move(cell: Cell):
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func move():
	# maybe have default move here and have input parameters from child classes
	# e.g. movement probabilites
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func differenciate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func generate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
	
func emanate():
	push_error("CellStateHandler base implementation should not be used. Use one of the subclasses instead.")
