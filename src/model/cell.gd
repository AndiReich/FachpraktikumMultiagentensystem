class_name Cell
# imports
var CellStateHandler = load("res://src/model/cellStateHandler.gd")

var cellStateHandler: CellStateHandler = CellStateHandler.new()

func next_move():
	## this is the only function that should be called for the cellStateHandler
	cellStateHandler.next_move(self)

func set_state(cellStateHandler: CellStateHandler):
	self.cellStateHandler = cellStateHandler
