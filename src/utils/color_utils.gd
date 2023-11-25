static func get_specific_permutation_with_overlay(base: Image, overlay: Image, range_of_mutations: int, index: int) -> Image:
	var overlay_copy = Image.new()
	overlay_copy.copy_from(overlay)
	var base_copy = Image.new()
	base_copy.copy_from(base)
	var new_color = calculate_color(index, range_of_mutations)
	var colored_overlay = change_color(overlay_copy, new_color)
	var image = blend_textures(base_copy, colored_overlay)
	return image
	
static func get_specific_permutation(base: Image, range_of_mutations: int, index: int) -> Image:
	var base_copy = Image.new()
	base_copy.copy_from(base)
	var new_color = calculate_color(index, range_of_mutations)
	var image = change_color(base_copy, new_color)
	return image

static func get_base_permutations_with_overlay(base: Image, overlay : Image, range_of_mutations: int) -> Array:
	var result_images = []
	for i in range(range_of_mutations):
		var overlay_copy = Image.new()
		overlay_copy.copy_from(overlay)
		var base_copy = Image.new()
		base_copy.copy_from(base)
		var new_color = calculate_color(i, range_of_mutations)
		var colored_overlay = change_color(overlay_copy, new_color)
		var image = blend_textures(base_copy, colored_overlay)
		result_images.append(image)
		
	return result_images
	
static func get_base_permutations(base: Image, range_of_mutations: int) -> Array:
	var result_images = []
	for i in range(range_of_mutations):
		var base_copy = Image.new()
		base_copy.copy_from(base)
		var new_color = calculate_color(i, range_of_mutations)
		var base_colored = change_color(base_copy, new_color)
		result_images.append(base_colored)
		
	return result_images

static func calculate_color(index, total_colors) -> Color:
	var hue = float(index) / float(total_colors)
	var saturation = 0.75
	var lightness = 0.5
	return Color.from_ok_hsl(hue, saturation, lightness)
	
static func change_color(image: Image, new_color: Color) -> Image:
	for y in image.get_height():
		for x in image.get_width():
			var pixel = image.get_pixel(x, y)
			var alpha = pixel.a
			var red = pixel.r8
			var green = pixel.g8
			var blue = pixel.b8
			if(!alpha == 0 && red == 255 && green == 255 && blue == 255):
				var color_with_alpha = Color(new_color, alpha)
				image.set_pixel(x, y, color_with_alpha)
	return image
	
static func blend_textures(base: Image, overlay: Image) -> Image:
	overlay.blend_rect(base, Rect2i(Vector2.ZERO, base.get_size()), Vector2i.ZERO)
	return overlay
