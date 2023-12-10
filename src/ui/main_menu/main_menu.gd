extends Control

var current_code: int = 0
var selected_code: Array = [0,0,0,0]
var preview_image: Image
var preview_texture_node: TextureRect
var color_utils = preload("res://src/utils/color_utils.gd")
var range_of_mutations: int = 16
var virus_image = Image.load_from_file("res://assets/cells/Antigen.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	preview_texture_node = find_child("TextureRect", true, false)
	recalculate_sprite()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.initial_macrophage_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/MacrophageLineEdit.text), 0, 100)
	Global.initial_apc_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/ApcLineEdit.text), 0, 100)
	Global.initial_b_cell_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/BCellLineEdit.text), 0, 100)
	Global.initial_act_b_cell_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/ActBCellLineEdit.text), 0, 100)
	Global.initial_t_cell_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/TCellLineEdit.text), 0, 100)
	Global.initial_act_t_cell_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/ActTCellLineEdit.text), 0, 100)
	Global.initial_p_cell_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/PCellLineEdit.text), 0, 100)
	Global.initial_virus_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/VirusLineEdit.text), 0, 100)
	Global.initial_antibody_count = parse_and_convert_input(int($CanvasLayer/HBoxContainer/MarginContainer/AgentsVBoxContainer/GridContainer/AntibodyLineEdit.text), 0, 100)

	Global.initial_direct_motion = parse_and_convert_input(float($CanvasLayer/HBoxContainer/MarginContainer2/ParametersVBoxContainer/GridContainer/DirectLineEdit.text), 0.0, 1.0)
	Global.initial_brownian_motion = parse_and_convert_input(float($CanvasLayer/HBoxContainer/MarginContainer2/ParametersVBoxContainer/GridContainer/BrownianMotionLineEdit.text), 0.0, 1.0)
	Global.initial_il_motion = parse_and_convert_input(float($CanvasLayer/HBoxContainer/MarginContainer2/ParametersVBoxContainer/GridContainer/ILLineEdit.text), 0.0, 1.0)
	
	Global.color_code = current_code
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func parse_and_convert_input(number, lower_limit, upper_limit):
	if number < lower_limit:
		return lower_limit
	if number > upper_limit:
		return upper_limit
		
	return number

func recalculate_sprite():
	var code_array = selected_code.duplicate()
	code_array.reverse()
	var resulting_int = 0 
	for index in code_array.size():
		resulting_int+= pow(2,index) * code_array[index]
	current_code = resulting_int
	
	var image = color_utils.get_specific_permutation(virus_image, range_of_mutations, current_code)
	preview_texture_node.texture = ImageTexture.create_from_image(image)
