extends TextureButton

func _pressed() -> void:
	get_tree().reload_current_scene()

func changed_button_to_dead():
	texture_normal = Constants.BUTTON_DEAD_IMAGE
