extends Label
func _process(delta):
	set_text("FPS %s" % Engine.get_frames_per_second())
