extends Node2D

@onready var head: Area2D = $Head
@onready var sine_wave: Node2D = $SineWave
@onready var timer: Timer = $Timer

enum GameMode{FAST, SLOW}
@export var gamemode: GameMode = GameMode.SLOW

const COLLECTABLE = preload("res://collectable.tscn")

var x_pos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	match gamemode:
		GameMode.SLOW:
			timer.start(randf_range(3.0, 5.0))
		GameMode.FAST:
			timer.start(randf_range(2.0, 3.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var arr = sine_wave.update_array()
	#var speed = arr[x_pos].distance_to(arr[x_pos + 1])
	#x_pos += delta * 100.0 / speed
	#x_pos = wrapf(x_pos, 0.0, get_viewport_rect().size.x)
	head.global_position =  arr[-2] + sine_wave.global_position
	head.look_at(arr[-1] + sine_wave.global_position)
	for collectable in get_tree().get_nodes_in_group("Collectables"):
		collectable.check_collision_with_wave(arr, sine_wave.global_position)

func _on_head_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables"):
		area.queue_free()


func _on_timer_timeout() -> void:
	var collectable = COLLECTABLE.instantiate() as Collectable
	add_child(collectable)
	collectable.global_position = Vector2( 
		get_viewport_rect().size.x + collectable.collision_shape_2d.shape.radius, 
		randf_range(
		get_viewport_rect().size.y/2 - 200, 
		get_viewport_rect().size.y/2 + 200))
	match gamemode:
		GameMode.SLOW:
			collectable.speed = 100.0
			timer.start(randf_range(3.0, 5.0))
		GameMode.FAST:
			collectable.speed = 150.0
			timer.start(randf_range(2.0, 3.0))


func _on_slow_button_pressed() -> void:
	gamemode = GameMode.SLOW


func _on_fast_button_pressed() -> void:
	gamemode = GameMode.FAST
