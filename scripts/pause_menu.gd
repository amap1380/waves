extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.visible = not self.visible
		get_tree().paused = not get_tree().paused

func _ready() -> void:
	self.visible = false

func _on_resume_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false

func _on_restart_button_pressed() -> void:
	SceneManager.change_scene(self, "uid://cw8000sdbix1t")
	get_tree().paused = false
	

func _on_main_menu_button_pressed() -> void:
	SceneManager.change_scene(self, "uid://cf4syy582ntfu")
	get_tree().paused = false
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
