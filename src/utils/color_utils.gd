static func get_base_permutations_with_overlay(base: Image, overlay : Image, range_of_mutations):
	var result_images = []
	for i in range(range_of_mutations):
		var overlay_copy = Image.new()
		overlay_copy.copy_from(overlay)
		var new_color = calculate_color(i, range_of_mutations)
		var colored_overlay = change_color(overlay_copy, new_color)
		var image = blend_textures(colored_overlay, base)
		result_images.append(image)
		
	return result_images

static func calculate_color(index, total_colors):
	var hue = float(index) / float(total_colors)
	var saturation = 0.75
	var lightness = 0.5
	return Color.from_ok_hsl(hue, saturation, lightness)
	
static func change_color(image: Image, new_color: Color):
	for y in image.get_height():
		for x in image.get_width():
			var alpha = image.get_pixel(x, y).a
			if(!alpha == 0):
				var color_with_alpha = Color(new_color, alpha)
				image.set_pixel(x, y, color_with_alpha)
	return image
	
static func blend_textures(image1: Image, image2: Image):
	image1.blend_rect(image2, Rect2i(Vector2.ZERO, image2.get_size()), Vector2i.ZERO)
	return image1
