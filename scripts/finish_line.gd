extends Area2D

@export var speed = 0


func _on_area_entered(area: Area2D) -> void:
	if area is Head:
		SignalBus.level_finished.emit()

func _physics_process(delta: float) -> void:
	self.global_position.x -= speed * delta
