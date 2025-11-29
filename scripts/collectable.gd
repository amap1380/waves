extends Area2D
class_name Collectable

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var speed = 100.0
@export_range(0, 3) var energy_level := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(global_position)
	match energy_level:
		0:
			sprite_2d.self_modulate = Color.RED
		1:
			sprite_2d.self_modulate = Color("4D846B")
		2:
			sprite_2d.self_modulate = Color("A526AE")
		3:
			sprite_2d.self_modulate = Color("5973FF")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	self.global_position.x -= speed * delta
	if self.global_position.x < -collision_shape_2d.shape.radius:
		queue_free()

	
func check_collision_with_wave(arr: PackedVector2Array, offset: Vector2):
	for i in arr.size() - 1:
		if Geometry2D.segment_intersects_circle(arr[i], arr[i+1], 
			collision_shape_2d.global_position - offset, collision_shape_2d.shape.radius) != -1:
				#print(2)
				return true
	return false
