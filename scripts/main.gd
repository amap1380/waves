extends Node2D

@onready var head: Area2D = $SineWave/Head
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


var MAX_POSITIVE: int = 0
var MAX_NEGETIVE: int = 0

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
	SignalBus.level_finished.connect(_on_level_finished)
	
	
	var level: Level = LevelManager.levels[LevelManager.current_level - 1].instantiate()
	self.add_child(level)
	
	MAX_POSITIVE = level.max_positive * level.number_of_orbs
	MAX_NEGETIVE = -level.max_negetive * level.number_of_orbs
	for i in level.number_of_orbs:
		var new_orb:OrbsUI = ORBS_UI.instantiate()
		orbs_container.add_child(new_orb)
		new_orb.max_value = level.max_positive
		new_orb.negetive_max_value = level.max_negetive

	var finish_line:Node2D =  get_tree().get_first_node_in_group("FinishLine")
	day_night_cycle.finish_line = finish_line
	day_night_cycle.init_pos_x = finish_line.global_position.x
	day_night_cycle_shader.finish_line = finish_line
	day_night_cycle_shader.init_pos_x = finish_line.global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var arr = sine_wave.arr

	for collectable: Collectable in get_tree().get_nodes_in_group("Collectables"):
		if collectable.is_on_screen() :
			if collectable.check_collision_with_wave(arr, sine_wave.global_position):
				pass
	#if camera_2d.zoom > Vector2(1,1):
		#camera_2d.zoom -= Vector2(0.0005,0.0005)
	#elif camera_2d.zoom > Vector2(0.7,0.7):
		#camera_2d.zoom -= Vector2(0.0001,0.0001)






func _on_collectable_crossed(_collectable: Collectable):
	pass


func _on_level_finished():
	if positive_score >= MAX_POSITIVE:
		sine_wave.ascend()
		LevelManager.current_level += 1
	elif positive_score < float(MAX_POSITIVE) / 2 or negetive_score < float(MAX_NEGETIVE) / 2:
		sine_wave.descend()
		LevelManager.current_level -= 1
	else:
		sine_wave.stay()
	await get_tree().create_timer(Constants.SINE_WAVE_TRANSITION_TIME/4).timeout
	SceneManager.change_scene(self,"res://scenes/dialogue_screen.tscn")


func _on_button_pressed() -> void:
	SceneManager.change_scene(self, "res://scenes/level_select.tscn")



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
	if area.score < 0:
		camera_2d.add_screen_shake(4, 0.2)
		var current_orb:OrbsUI = orbs_container.get_child(orbs_container.negetive_index)
		current_orb.play_negetive_absorb_anim()
	elif area.score > 0 :
		var current_orb:OrbsUI = orbs_container.get_child(orbs_container.positive_index)
		current_orb.play_positive_absorb_anim()
		
	self.positive_score += area.score
	self.positive_score = clampi(self.positive_score, 0, MAX_POSITIVE)
	self.negetive_score += area.score
	self.negetive_score = clampi(self.negetive_score, MAX_NEGETIVE, 0)
	orbs_container.reset_orbs()
	orbs_container.test_positive(self.positive_score)
	orbs_container.test_negetive(abs(self.negetive_score))
	play_collected_sound()
