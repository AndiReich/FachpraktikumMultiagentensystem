extends Control

signal close(color_code: int)
var selected_code: Array = [0,0,0,0]
var range_of_mutations: int = 16
var current_code: int = 0
var overlay_image: Image
var preview_image: Image
var preview_texture_node: TextureRect
var color_utils = preload("res://src/utils/color_utils.gd")

func set_images(preview_image: Image, overlay_image: Image):
	self.preview_image = preview_image
	self.overlay_image = overlay_image
	preview_texture_node = find_child("TextureRect", true, false)
	recalculate_sprite()

func recalculate_sprite():
	var code_array = selected_code.duplicate()
	code_array.reverse()
	var resulting_int = 0 
	for index in code_array.size():
		resulting_int+= pow(2,index) * code_array[index]
	current_code = resulting_int
	
	if(overlay_image == null):
		var image = color_utils.get_specific_permutation(preview_image, range_of_mutations, current_code)
		preview_texture_node.texture = ImageTexture.create_from_image(image)
	else:
		var image = color_utils.get_specific_permutation_with_overlay(preview_image, overlay_image, range_of_mutations, current_code)
		preview_texture_node.texture = ImageTexture.create_from_image(image)
