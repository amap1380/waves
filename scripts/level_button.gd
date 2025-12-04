@tool
extends Button


const MAIN_SCENE = preload("res://scenes/main.tscn")

@export var level_num = 1:
	set(value):
		level_num = value
		text = str(value)

@export var unlocked: bool = true:
	set(value):
		disabled = value
		unlocked = value

func _ready() -> void:
	level_num = get_index() + 1


func _on_pressed() -> void:
	LevelManager.current_level = level_num
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	#var main_scene = MAIN_SCENE.instantiate()
	#if FileAccess.file_exists("res://scenes/levels/level_" + str(level_num) + ".tscn"):
		#var level = load("res://scenes/levels/level_" + str(level_num) + ".tscn") as PackedScene
		#var level_node = level.instantiate()
		#main_scene.add_child(level_node)
	#var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
	#get_tree().get_root().add_child(main_scene) # Adds the new scene to the scene tree. This MUST happen before assigning it as the current scene.
	#get_tree().current_scene = main_scene # Assigns our new scene as the current scene
	#current_scene.queue_free() # Now we can remove the original scene
