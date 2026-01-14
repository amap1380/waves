extends Area2D
class_name Head

signal devoured(area)

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables") and area is Collectable:
		area.absorb()
		animation_player.play("devour")
		devoured.emit(area)
