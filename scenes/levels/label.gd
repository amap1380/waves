extends Label

@export var speed = 200.0


func _physics_process(delta: float) -> void:
	self.global_position.x -= speed * delta
