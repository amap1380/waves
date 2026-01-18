extends Node2D

@onready var sine_wave: SineWave = $SineWave

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
		sine_wave.set_input("left", true)
		move_sine_wave()
