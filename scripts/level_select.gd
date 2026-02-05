extends Control

@onready var vertical_container: VBoxContainer = $AspectRatioContainer/CenterContainer/VerticalContainer

const LEVEL_BUTTON = preload("res://scenes/level_button.tscn")

func _ready() -> void:
	for i in range(LevelManager.max_level):
		var level_button = LEVEL_BUTTON.instantiate()
		vertical_container.add_child(level_button)
	#grid_container.get_child(0).unlocked = true


func _on_button_pressed() -> void:
	SceneManager.change_scene(self, "res://scenes/main_menu.tscn")
