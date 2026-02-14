extends Control
class_name OrbsUI

var max_value:int = 10
var negetive_max_value:int = 10



@onready var negetive_progress: Sprite2D = $NegetiveProgress
@onready var progress: Sprite2D = $Progress
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var value:int = 0:
	set(new_value):
		value = new_value
		progress.modulate.a = float(value) / max_value
		print(progress.modulate.a)

		
@export var negetive_value:int = 0:
	set(value):
		negetive_value = value
		negetive_progress.modulate.a = float(negetive_value) / negetive_max_value


func _ready() -> void:
	value = 0
	negetive_value = 0

func _process(_delta: float) -> void:
	pass
