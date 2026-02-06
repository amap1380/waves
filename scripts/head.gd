extends Area2D
class_name Head

signal devoured(area)

@export var sine_wave: SineWave

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionPolygon2D = $CollisionShape2D
@onready var head_sprite = $WholeHeadSprite/HeadSprite
var desat_material: ShaderMaterial


func _ready() -> void:
	desat_material = ShaderMaterial.new()
	desat_material.shader = load("res://assets/shaders/desaturate.gdshader")
	head_sprite.material = desat_material

func _process(_delta: float) -> void:
	_update_color_modulation()
	print("stamina:", sine_wave.stamina)



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables") and area is Collectable:
		area.absorb()
		animation_player.play("devour")
		devoured.emit(area)


func _update_color_modulation() -> void:
	if not sine_wave:
		return

	var stamina_value := sine_wave.stamina   # absolute value (0–150)

	var sat: float
	if stamina_value >= 80.0:
		sat = 1.0
	elif stamina_value <= 0.0:
		sat = 0.0
	else:
		sat = stamina_value / 80.0

	desat_material.set_shader_parameter("saturation", sat)

	print("stamina:", " saturation:", sat)
