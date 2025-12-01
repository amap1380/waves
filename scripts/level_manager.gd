extends Node

var current_level: int = 1
var level_unlocked: int = 1
var max_level: int = 3

func _unlock_level(level_to_unlock: int) -> void:
	if level_to_unlock > level_unlocked:
		pass
