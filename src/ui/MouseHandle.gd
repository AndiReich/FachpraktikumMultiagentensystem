extends Container

# images
var antibody_image = Image.load_from_file("res://assets/cells/Antibody.png")
var b_cell_image = Image.load_from_file("res://assets/cells/BCell.png")
var macrophage_image = Image.load_from_file("res://assets/cells/Macrophage.png")
var plasmacyte_image = Image.load_from_file("res://assets/cells/Plasmacyte.png")
var t_helper_cell_image = Image.load_from_file("res://assets/cells/THelperCell.png")
var virus_image = Image.load_from_file("res://assets/cells/Antigen.png")

# overlays
var b_cell_overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
var macrophage_overlay = Image.load_from_file("res://assets/cells/MacrophageOverlay.png")
var plasmacyte_overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
var t_helper_cell_overlay = Image.load_from_file("res://assets/cells/THelperCellOverlay.png")

var agent_scene = preload("res://scenes/agents/agent.tscn")
var code_selection_scene = preload("res://scenes/ui/antigen_code_selector.tscn")

var color_utils = preload("res://src/utils/color_utils.gd")
var range_of_mutations = 16

var agentRootNode
var simulationUINode

var selected_agent_type
var current_color_code = 0

func _ready():
	size = get_viewport().size
	agentRootNode = get_tree().root.find_child("AgentRootNode", true, false)
	simulationUINode = get_tree().root.find_child("SimulationUI", true, false)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and selected_agent_type != null:
			var agent = agent_scene.instantiate()
			if agent:
				agent.initialize_by_cell_type(selected_agent_type, current_color_code, range_of_mutations)
				var mouse_position = get_global_mouse_position()
				agentRootNode.add_child(agent)
				agent.position = mouse_position
				
func _on_agents_instantiate_agent(agentType):
	selected_agent_type = agentType
	match selected_agent_type:
		Cell.TYPES.MACROPHAGE:
			var resulting_texture = ImageTexture.create_from_image(macrophage_image)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.PLASMACYTE:
			var code = await select_antigen_code(plasmacyte_image, plasmacyte_overlay)
			var image_to_display = color_utils.get_specific_permutation_with_overlay(plasmacyte_image, plasmacyte_overlay, range_of_mutations, code)
			var resulting_texture = ImageTexture.create_from_image(image_to_display)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.THELPERCELL:
			var resulting_texture = ImageTexture.create_from_image(t_helper_cell_image)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.BCELL:
			var resulting_texture = ImageTexture.create_from_image(b_cell_image)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.ACTIVATEDBCELL:
			var code = await select_antigen_code(b_cell_image, b_cell_overlay)
			var image_to_display = color_utils.get_specific_permutation_with_overlay(b_cell_image, b_cell_overlay, range_of_mutations, code)
			var resulting_texture = ImageTexture.create_from_image(image_to_display)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.ANTIGENPRESENTINGCELL:
			var code = await select_antigen_code(macrophage_image, macrophage_overlay)
			var image_to_display = color_utils.get_specific_permutation_with_overlay(macrophage_image, macrophage_overlay, range_of_mutations, code)
			var resulting_texture = ImageTexture.create_from_image(image_to_display)
			Input.set_custom_mouse_cursor(resulting_texture)
		
		Cell.TYPES.ANTIGEN: 
			var code = await select_antigen_code(virus_image)
			var image_to_display = color_utils.get_specific_permutation(virus_image, range_of_mutations, code)
			var resulting_texture = ImageTexture.create_from_image(image_to_display)
			Input.set_custom_mouse_cursor(resulting_texture)
			
			current_color_code = code
		
		Cell.TYPES.ACTIVATEDTHELPERCELL:
			var code = await select_antigen_code(t_helper_cell_image, t_helper_cell_overlay)
			var image_to_display = color_utils.get_specific_permutation_with_overlay(t_helper_cell_image, t_helper_cell_overlay, range_of_mutations, code)
			var resulting_texture = ImageTexture.create_from_image(image_to_display)
			Input.set_custom_mouse_cursor(resulting_texture)

func select_antigen_code(preview_image: Image, overlay_image: Image = null):
	var code_selection = simulationUINode.find_child("antigen_code_selector", true, false)
	code_selection.set_images(preview_image, overlay_image)
	code_selection.show()
	var code = await code_selection.close
	code_selection.hide()
	return code
