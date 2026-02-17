extends Control
class_name OrbsUI

var max_value:int = 10
var negetive_max_value:int = 10

const ORB_ABSORB_ANIMATION = preload("uid://duykepqbpk51")


@onready var negetive_progress: Sprite2D = $NegetiveProgress
@onready var progress: Sprite2D = $Progress
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var value:int = 0:
	set(new_value):
		value = new_value
		if value >= max_value:
			animation_player.stop()
		progress.self_modulate.a = float(value) / max_value

		
@export var negetive_value:int = 0:
	set(value):
		negetive_value = value
		if negetive_value >= negetive_max_value:
			animation_player.stop()
		negetive_progress.self_modulate.a = float(negetive_value) / negetive_max_value

func play_negetive_absorb_anim():
	var anim :AnimatedSprite2D= ORB_ABSORB_ANIMATION.instantiate()
	anim.modulate = Color("#bb3c35")
	negetive_progress.add_child(anim)

func play_positive_absorb_anim():
	var anim :AnimatedSprite2D= ORB_ABSORB_ANIMATION.instantiate()
	anim.modulate = Color("#54ffa7")
	negetive_progress.add_child(anim)

func _ready() -> void:
	value = 0
	negetive_value = 0

func _process(_delta: float) -> void:
	pass
