extends Node2D

@onready var head: Area2D = $Head
@onready var sine_wave: SineWave = $SineWave
@onready var spawn_timer: Timer = $SpawnTimer
@onready var camera_2d: Camera2D = $Camera2D

enum GameMode{FAST, SLOW}
@export var gamemode: GameMode = GameMode.FAST
@export var random: bool = true
const COLLECTABLE = preload("res://scenes/collectable.tscn")

@onready var on_head_score_label: Label = $HUD/HBoxContainer/VBoxContainer2/OnHeadScore
@onready var on_body_score_label: Label = $HUD/HBoxContainer/VBoxContainer2/OnBodyScore
@onready var no_hit_score_label: Label = $HUD/HBoxContainer/VBoxContainer2/NoHitScore
@onready var mistake_score_label: Label = $HUD/HBoxContainer/VBoxContainer2/MistakeScore

var timerformusic : Timer
@onready var bg_music_player: AudioStreamPlayer = $BgMusic

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

var mistake_score := 0:
	set(value):
		if mistake_score != value:
			mistake_score = value
			mistake_score_label.text = str(value)

var x_pos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timerformusic = Timer.new()
	timerformusic.wait_time = 6.8 # duration in seconds
	timerformusic.one_shot = true
	add_child(timerformusic)
	timerformusic.timeout.connect(_on_timer_finished)
	#timerformusic.start()
	
	randomize()
	if random:
		match gamemode:
			GameMode.SLOW:
				spawn_timer.start(randf_range(3.0, 5.0))
			GameMode.FAST:
				spawn_timer.start(randf_range(2.0, 3.0))
	SignalBus.collectable_crossed.connect(_on_collectable_crossed)
	
	var level = LevelManager.levels[LevelManager.current_level - 1].instantiate()
	self.add_child(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var arr = sine_wave.arr
	#var speed = arr[x_pos].distance_to(arr[x_pos + 1])
	#x_pos += delta * 100.0 / speed
	#x_pos = wrapf(x_pos, 0.0, get_viewport_rect().size.x)
	head.global_position =  arr[-2] + sine_wave.global_position
	head.look_at(arr[-1] + sine_wave.global_position)
	for collectable: Collectable in get_tree().get_nodes_in_group("Collectables"):
		if collectable.is_on_screen() :
			if collectable.check_collision_with_wave(arr, sine_wave.global_position):
				#if collectable.energy_level == sine_wave.energy_level:
					#self.on_body_score += 1
				#else:
					#self.mistake_score += 1
					#camera_2d.add_trauma(0.3)
				#collectable.queue_free()
				pass

func _on_head_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables") and area is Collectable:
		#if area.energy_level < sine_wave.energy_level:
			#self.on_head_score += 1
		#else:
			#self.mistake_score += 1
			#camera_2d.add_trauma(0.3)
		area.absorb()





func _on_collectable_crossed(collectable: Collectable):
	pass
	#if sine_wave.energy_level < collectable.energy_level:
		#self.no_hit_score += 1
	#else:
		#self.mistake_score += 1
		#camera_2d.add_trauma(0.3)

func _on_slow_button_pressed() -> void:
	gamemode = GameMode.SLOW


func _on_fast_button_pressed() -> void:
	gamemode = GameMode.FAST


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_timer_finished():
	bg_music_player.play()


func _on_spawn_timer_timeout() -> void:
	var collectable = COLLECTABLE.instantiate() as Collectable
	collectable.type = randi_range(0, collectable.TYPE.size() - 1)
	add_child(collectable)
	collectable.global_position = Vector2( 
		get_viewport_rect().size.x + collectable.collision_shape_2d.shape.radius, 
		randf_range(
		get_viewport_rect().size.y/2 - 200, 
		get_viewport_rect().size.y/2 + 200))
	match gamemode:
		GameMode.SLOW:
			collectable.speed = 100.0
			spawn_timer.start(randf_range(3.0, 5.0))
		GameMode.FAST:
			collectable.speed = 150.0
			spawn_timer.start(randf_range(2.0, 3.0))
