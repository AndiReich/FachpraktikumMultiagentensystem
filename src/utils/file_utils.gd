class_name FileUtils

var export_path = "user://"

var file

# on windows exports to the following path: C:\Users\{username}\AppData\Roaming\Godot\app_userdata\Fachpraktikum Multiagentensystem
func open_writer():
	
	var start_time = Time.get_datetime_string_from_system().replace(":","-")
	
	var filename = "cell-simulation-export-" + start_time + ".csv"
	var path = export_path + filename
	self.file = FileAccess.open(path, FileAccess.WRITE)
	self.file.store_csv_line(["cell_id", "cell_type", "cell_pos_x", "cell_pos_y", "antigen_code", "time"])

func save_cell_state_to_csv(cell: Cell):
	var time = Time.get_datetime_string_from_system()
	var id = cell.get_instance_id()
	var type = Cell.TYPES.find_key(cell.cell_state_handler.cell_type).to_lower()
	var pos_x = cell.position.x
	var pos_y = cell.position.y
	var antigen_code = cell.cell_state_handler.color_code
	if type == "macrophage" || type == "bcell" || type == "thelpercellt4":
		# fix for antigen_code because I didnt want to waste more time 
		# looking for the place where we assign it to 0 instead of -1
		antigen_code = -1
	
	var line = [id, type, pos_x, pos_y, antigen_code, time]
	self.file.store_csv_line(line)
	
func close_writer():
	self.file.close()
	

