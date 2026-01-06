extends Control


func _on_play_button_pressed() -> void:
		SceneManager.change_scene(self, "res://scenes/level_select.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
