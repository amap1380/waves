extends Node2D

@onready var sine_wave: SineWave = $SineWave
@onready var camera_2d: Camera2D = %Camera2D
@onready var head: Head = $SineWave/Head

var tween : Tween

func move_sine_wave():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(sine_wave, "global_position:x",
	 sine_wave.global_position.x + get_viewport_rect().size.x, 0.6)
	tween.parallel().tween_property(sine_wave, "ratio", 0.1, 0.6)
	

func _ready() -> void:
	sine_wave.set_input("up", false)
	sine_wave.set_input("down", false)
	sine_wave.set_input("left", false)
	sine_wave.sine_speed = 0.0


func _on_green_star_area_entered(area: Area2D) -> void:
	if area is Head:
		sine_wave.sine_speed = 2.0
		var amp_tween: Tween = get_tree().create_tween()
		amp_tween.tween_property(sine_wave,"amplitude", 180, 0.6)
		sine_wave.set_input("left", true)
		move_sine_wave()
		camera_2d.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
		camera_2d.offset.x = 360
		camera_2d.position.y = 0
		camera_2d.get_parent().remove_child(camera_2d)
		head.add_child(camera_2d)
