extends Node2D

@onready var head: Area2D = $Head
@onready var sine_wave: SineWave = $SineWave
@onready var spawn_timer: Timer = $SpawnTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var day_night_cycle: CanvasModulate = $DayNightCycle
@onready var day_night_cycle_shader: CanvasLayer = $DayNightCycleShader

enum GameMode{FAST, SLOW}
@export var gamemode: GameMode = GameMode.FAST
@export var random: bool = true
const COLLECTABLE = preload("res://scenes/collectable.tscn")
const ORBS_UI = preload("uid://bytsjkgf1g428")

@onready var orbs_container: HBoxContainer = $HUD/OrbsContainer


@onready var bg_music_player: AudioStreamPlayer = $Sounds/BgMusic

@onready var sfx_player: AudioStreamPlayer = $Sounds/SFX
@export var collected_sounds: Array[AudioStream]



var positive_score: int = 0
var negetive_score: int = 0


var x_pos = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	randomize()
	if random:
		match gamemode:
			GameMode.SLOW:
				spawn_timer.start(randf_range(3.0, 5.0))
			GameMode.FAST:
				spawn_timer.start(randf_range(2.0, 3.0))
	SignalBus.collectable_crossed.connect(_on_collectable_crossed)
	
	var level: Level = LevelManager.levels[LevelManager.current_level - 1].instantiate()
	self.add_child(level)
	for i in level.number_of_orbs:
		var new_orb:OrbsUI = ORBS_UI.instantiate()
		orbs_container.add_child(new_orb)
		new_orb.max_value = level.max_positive
		new_orb.negetive_bar.max_value = level.max_negetive

	var finish_line:Node2D =  get_tree().get_first_node_in_group("FinishLine")
	day_night_cycle.finish_line = finish_line
	day_night_cycle.init_pos_x = finish_line.global_position.x
	day_night_cycle_shader.finish_line = finish_line
	day_night_cycle_shader.init_pos_x = finish_line.global_position.x


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






func _on_collectable_crossed(_collectable: Collectable):
	pass
	#if sine_wave.energy_level < collectable.energy_level:
		#self.no_hit_score += 1
	#else:
		#self.mistake_score += 1
		#camera_2d.add_trauma(0.3)



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")



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



func play_collected_sound():
	if collected_sounds.is_empty():
		return

	var p := AudioStreamPlayer.new()
	p.stream = collected_sounds.pick_random()
	p.bus = "SFX"
	p.volume_db = -27
	p.pitch_scale = 0.8 + randf_range(-0.2, 0.2)
	add_child(p)
	p.play()

	p.finished.connect(func():
		p.queue_free()
)


func _on_head_devoured(area: Collectable) -> void:
	self.positive_score += area.score
	self.positive_score = maxi(self.positive_score, 0)
	self.negetive_score += area.score
	self.negetive_score = mini(self.negetive_score, 0)
	orbs_container.set_positive(self.positive_score)
	orbs_container.set_negetive(abs(self.negetive_score))
	play_collected_sound()
