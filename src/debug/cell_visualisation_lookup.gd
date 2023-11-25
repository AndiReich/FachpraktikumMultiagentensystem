extends Node2D

const color_utils = preload("res://src/utils/color_utils.gd")

var range_of_mutations = 16

func _ready():
	show_antibody()
	show_antigen()
	show_b_cell()
	show_macrophage()
	show_plasmacyte()
	show_t_helper_cell()
	
	test_specific_antigen()
	
func test_specific_antigen():
	var base = Image.load_from_file("res://assets/cells/Antigen.png")
	var image = color_utils.get_specific_permutation(base, range_of_mutations, 1)
	var sprite = Sprite2D.new()
	sprite.scale = Vector2(3,3)
	sprite.position = Vector2(64, 96*7)
	sprite.texture = ImageTexture.create_from_image(image)
	add_child(sprite)
		
func show_antibody():
	var base =  Image.load_from_file("res://assets/cells/Antibody.png")
	var images = color_utils.get_base_permutations(base, range_of_mutations)
	show_images_from_y_position(images, 96)
	
func show_antigen():
	var base =  Image.load_from_file("res://assets/cells/Antigen.png")
	var images = color_utils.get_base_permutations(base, range_of_mutations)
	show_images_from_y_position(images, 96*2)
	
func show_b_cell():
	var base =  Image.load_from_file("res://assets/cells/BCell.png")
	var overlay = Image.load_from_file("res://assets/cells/BCellOverlay.png")
	var images = color_utils.get_base_permutations_with_overlay(base, overlay, range_of_mutations)
	show_images_from_y_position(images, 96*3)
		
func show_macrophage():
	var base =  Image.load_from_file("res://assets/cells/Macrophage.png")
	var overlay = Image.load_from_file("res://assets/cells/MacrophageOverlay.png")
	var images = color_utils.get_base_permutations_with_overlay(base, overlay, range_of_mutations)
	show_images_from_y_position(images, 96*4)
	
func show_plasmacyte():
	var base =  Image.load_from_file("res://assets/cells/Plasmacyte.png")
	var overlay = Image.load_from_file("res://assets/cells/PlasmacyteOverlay.png")
	var images = color_utils.get_base_permutations_with_overlay(base, overlay, range_of_mutations)
	show_images_from_y_position(images, 96*5)
	
func show_t_helper_cell():
	var base =  Image.load_from_file("res://assets/cells/THelperCell.png")
	var overlay = Image.load_from_file("res://assets/cells/THelperCellOverlay.png")
	var images = color_utils.get_base_permutations_with_overlay(base, overlay, range_of_mutations)
	show_images_from_y_position(images, 96*6)
	
func show_images_from_y_position(images : Array, y: int):
	for i in (range_of_mutations):			
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(3,3)
		sprite.position = Vector2(i * 96 + 64, y)
		sprite.texture = ImageTexture.create_from_image(images[i])
		add_child(sprite)
