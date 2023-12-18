class_name ChartController extends Control

@onready var chart: Chart = $Chart

var color_utils = preload("res://src/utils/color_utils.gd")
var file_utils

var functions : Dictionary = {}
var update_cooldown = 1.0
var update_timer = 0.0
var elapsed_seconds = 0
var should_pause = false
var agent_root_node



func _ready():	
	file_utils = FileUtils.new()
	file_utils.open_writer()
	agent_root_node = get_tree().root.find_child("AgentRootNode", true, false)
	
	var chart_properties = initialize_chart_properties()
		
	for cell_type in Cell.TYPES.values():
		functions[cell_type] = create_function_for_cell_type(cell_type)
		
	# start of doing weird shit in godot
	var functions_to_plot: Array[Function] = []
	for index in range(functions.size()): # size instead of keys or values to ensure order
		functions_to_plot.append(functions[index] as Function)
	chart.plot(functions_to_plot, chart_properties)
	# end of doing weird shit in godot

func create_function_for_cell_type(type_id: int) -> Function:
	var color_to_set = color_utils.calculate_color(type_id, Cell.TYPES.size())
	var cell_type_string = Cell.TYPES.find_key(type_id).to_lower()
	
	var x = PackedInt32Array([0,0])
	var y = PackedInt32Array([0,0])
	var function : Function = Function.new(
		x, y, "%s count" % cell_type_string,
		{ 
			color = color_to_set,
			marker = Function.Marker.CIRCLE,
			type = Function.Type.LINE,
			interpolation = Function.Interpolation.STAIR
		}
	)
	return function

func _process(delta: float):
	update_timer += delta
	if(update_timer >= update_cooldown):
		# gets all agent nodes and their cell type
		var cells = fetch_cells()
		var cell_counts = fetch_cell_counts(cells)
		
		for cell in cells:
			file_utils.save_cell_state_to_csv(cell)
		
		# updates the functions for each cell type
		for key in functions.keys():
			var function = functions[key] as Function
			var count_for_type = cell_counts.get(key)
			if(count_for_type == null):
				# draws 0 for the cell_type (otherwise the cell would be stuck)
				function.add_point(elapsed_seconds, 0)
			else:
				function.add_point(elapsed_seconds, count_for_type)
			if(function.count_points() >= 100):
				function.remove_point(0)	
		if(should_pause == true):
			return
		else:
			chart.queue_redraw() # This forces the Chart to be updated
		elapsed_seconds += int(update_cooldown)
		update_timer = 0.0

func initialize_chart_properties() -> ChartProperties:
	var chart_properties: ChartProperties = ChartProperties.new()
	chart_properties.colors.frame = Color("#161a1d")
	chart_properties.colors.background = Color.TRANSPARENT
	chart_properties.colors.grid = Color("#283442")
	chart_properties.colors.ticks = Color("#283442")
	chart_properties.colors.text = Color.WHITE_SMOKE
	chart_properties.draw_bounding_box = false
	chart_properties.show_title = true
	chart_properties.title = "Agents by type"
	chart_properties.y_label = "Cell count"
	chart_properties.interactive = true 
	chart_properties.smooth_domain = true
	chart_properties.y_scale = 1
	return chart_properties


func fetch_cells() -> Array[Node]:
	return agent_root_node.get_children()
		
func fetch_cell_counts(agent_nodes: Array[Node]) -> Dictionary:
	var cell_counter = {}
	for agent_node in agent_nodes:
		var cell = agent_node as Cell
		var cell_type = cell.cell_state_handler.cell_type
		if(cell_counter.get(cell_type) != null):
			cell_counter[cell_type] += 1
		else:
			cell_counter[cell_type] = 1
			
	return cell_counter
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		file_utils.close_writer()
		get_tree().quit() # default behavior
