extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func change_scene(from, to_scene_name: String):
	
	animation_player.play("transition_out")
	await animation_player.animation_finished
	#if not get_tree().paused:
		#get_tree().paused = true
	from.get_tree().change_scene_to_file.call_deferred(to_scene_name)
	
	animation_player.play("transition_in")
	await animation_player.animation_finished
	
	#if get_tree().paused:
		#get_tree().paused = false
