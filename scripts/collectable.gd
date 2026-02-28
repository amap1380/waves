extends Area2D
class_name Collectable

var tween: Tween

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var eye: Sprite2D = $Eye

@export var speed = 100.0
@export var score:int = 0

func _ready() -> void:
	point_light_2d.enabled = false



func _physics_process(delta: float) -> void:
	self.global_position.x -= speed * delta
	if self.global_position.x < 0:
		SignalBus.collectable_crossed.emit()
		queue_free()


	
func check_collision_with_wave(arr: PackedVector2Array, offset: Vector2):
	for i in arr.size() - 1:
		if Geometry2D.segment_intersects_circle(arr[i], arr[i+1], 
			collision_shape_2d.global_position - offset, collision_shape_2d.shape.radius) != -1:
				return true
	return false

func is_on_screen() -> bool:
	return visible_on_screen_notifier_2d.is_on_screen()

func absorb() -> void:
	_despawn()

func _despawn():
	self.collision_shape_2d.set_deferred("disabled", true)
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self.sprite_2d,"scale", Vector2.ZERO, 0.4)
	tween.tween_property(self.eye,"scale", Vector2.ZERO, 0.4)
	tween.parallel().tween_property(self,"modulate", Color(0.0, 0.0, 0.0, 0.0), 0.4)
	tween.parallel().tween_property(self.collision_shape_2d.shape,"radius", 0, 0.4)
	tween.parallel().tween_property(self.point_light_2d,"texture_scale", 0, 0.4)
	tween.tween_callback(self.queue_free)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	point_light_2d.enabled = true
