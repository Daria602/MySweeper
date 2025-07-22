extends TextureButton

func _pressed() -> void:
	get_tree().reload_current_scene()

func changed_button_to_dead():
	print("DEAD")
