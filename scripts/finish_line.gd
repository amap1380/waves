extends Area2D

@export var speed = 0


func _on_area_entered(area: Area2D) -> void:
	if area is Head:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _physics_process(delta: float) -> void:
	self.global_position.x -= speed * delta
