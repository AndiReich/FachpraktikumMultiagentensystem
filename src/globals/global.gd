extends Node

var initial_macrophage_count = 0
var initial_apc_count = 0
var initial_b_cell_count = 0
var initial_act_b_cell_count = 0
var initial_t_cell_count = 0
var initial_act_t_cell_count = 0
var initial_p_cell_count = 0
var initial_virus_count = 0
var initial_antibody_count = 0

var initial_brownian_motion: float = 1.0
var initial_il_motion: float = 1.0
var initial_direct_motion: float = 1.0

var color_code = 0

var antibody_image = Image.load_from_file("res://assets/cells/Antibody.png")
var b_cell_image = Image.load_from_file("res://assets/cells/BCell.png")
var macrophage_image = Image.load_from_file("res://assets/cells/Macrophage.png")
var plasmacyte_image = Image.load_from_file("res://assets/cells/Plasmacyte.png")
var t_helper_cell_image = Image.load_from_file("res://assets/cells/THelperCell.png")
var virus_image = Image.load_from_file("res://assets/cells/Antigen.png")
var delete_image = Image.load_from_file("res://assets/ui/TrashIcon.png")

var b_cell_overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
var macrophage_overlay = Image.load_from_file("res://assets/cells/MacrophageOverlay.png")
var plasmacyte_overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
var t_helper_cell_overlay = Image.load_from_file("res://assets/cells/THelperCellOverlay.png")
