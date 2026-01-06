extends Node

@export var levels: Array[PackedScene] = []
#@export var level_dialogues: Array[Dialogue] = []

var current_level: int = 1:
	set(value):
		current_level = clampi(value, 1, levels.size())
var level_unlocked: int = 1
var max_level: int = 0



func _unlock_level(level_to_unlock: int) -> void:
	if level_to_unlock > level_unlocked:
		pass

func _ready() -> void:
	max_level = levels.size()
