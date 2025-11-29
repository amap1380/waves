extends Node2D

@onready var head: Area2D = $Head
@onready var sine_wave: SineWave = $SineWave
@onready var timer: Timer = $Timer

enum GameMode{FAST, SLOW}
@export var gamemode: GameMode = GameMode.FAST
@export var random: bool = true
const COLLECTABLE = preload("res://scenes/collectable.tscn")

@onready var on_head_score_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer2/OnHeadScore
@onready var on_body_score_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer2/OnBodyScore
@onready var no_hit_score_label: Label = $CanvasLayer/HBoxContainer/VBoxContainer2/NoHitScore

var no_hit_score := 0:
	set(value):
		if no_hit_score != value:
			no_hit_score = value
			no_hit_score_label.text = str(value)

var on_body_score := 0:
	set(value):
		if on_body_score != value:
			on_body_score = value
			on_body_score_label.text = str(value)
var on_head_score := 0:
	set(value):
		if on_head_score != value:
			on_head_score = value
			on_head_score_label.text = str(value)

var x_pos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	if random:
		match gamemode:
			GameMode.SLOW:
				timer.start(randf_range(3.0, 5.0))
			GameMode.FAST:
				timer.start(randf_range(2.0, 3.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var arr = sine_wave.arr
	#var speed = arr[x_pos].distance_to(arr[x_pos + 1])
	#x_pos += delta * 100.0 / speed
	#x_pos = wrapf(x_pos, 0.0, get_viewport_rect().size.x)
	head.global_position =  arr[-2] + sine_wave.global_position
	head.look_at(arr[-1] + sine_wave.global_position)
	for collectable in get_tree().get_nodes_in_group("Collectables"):
		if collectable.check_collision_with_wave(arr, sine_wave.global_position):
			if collectable.energy_level == sine_wave.energy_level:
				self.on_body_score += 1
			if collectable.energy_level > sine_wave.energy_level:
				self.no_hit_score += 1
			collectable.queue_free()

func _on_head_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables"):
		if area.energy_level < sine_wave.energy_level:
			self.on_head_score += 1
		area.queue_free()


func _on_timer_timeout() -> void:
	var collectable = COLLECTABLE.instantiate() as Collectable
	collectable.energy_level = randi_range(1,3)
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
