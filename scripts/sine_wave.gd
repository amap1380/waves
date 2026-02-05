extends Node2D
class_name SineWave

@onready var body: Line2D = $Body
@onready var spikes: Line2D = $Spikes
@onready var bar = $"../HUD/StaminaBar"

var desat_material: ShaderMaterial


@export var amplitude = 100.0:
	set(value):
		if amplitude != value:
			amplitude = value
			queue_redraw()
@export var frequency = 50.0:
	set(value):
		if frequency != value:
			frequency = value
			queue_redraw()

var h = 0.0
@export var speed := 1.0
@export var sine_speed := 2.0

@export var number_of_points = 1000:
	set(value):
		if number_of_points != value:
			number_of_points = value
			queue_redraw()

@export var gradient_1: Gradient
@export var gradient_2: Gradient
@export var gradient_3: Gradient

var ratio = 0.1
@onready var collison_polygone : Array[PackedVector2Array]
var arr = PackedVector2Array()
var color: Color
var energy_level := 0

# --- STAMINA SYSTEM ---
@export_group("Stamina")
@export var max_stamina := 100.0
@export var stamina_drain_rate := 20.0
@export var stamina_regen_rate := 10.0
@export var stamina_threshold := 5.0

var stamina: float
var can_input := true

func _ready() -> void:
	stamina = max_stamina
	update_array()
	queue_redraw()
	
	#for desaturation look
	stamina = max_stamina

	desat_material = ShaderMaterial.new()
	desat_material.shader = load("res://assets/shaders/desaturate.gdshader")

	body.material = desat_material
	spikes.material = desat_material


func _physics_process(delta: float) -> void:
	_update_stamina(delta)

	# --- Base wave logic (always runs) ---
	h += delta * sine_speed
	wrapf(h, 0, TAU)

	# --- Only apply player input if allowed ---
	var input_x := 0.0
	var input_y := 0.0
	if can_input:
		input_x = Input.get_axis("left", "right")
		input_y = Input.get_axis("down", "up")

	ratio += input_x * delta * speed / 5.0
	ratio = clampf(ratio, 0.0, 1.0)

	number_of_points = int(lerp(100.0, get_viewport_rect().size.x - 100.0, ratio))
	amplitude += input_y * delta * speed * 100.0
	amplitude = clampf(amplitude, 0.0, 200.0)

	frequency = lerpf(50.0, 200.0, ratio)

	update_array()
	body.points = arr
	spikes.points = arr
	queue_redraw()

	_update_color_modulation() # <--- NEW visual call
	

# --- STAMINA LOGIC ---
func _update_stamina(delta: float) -> void:
	var using_input := Input.is_action_pressed("left") or Input.is_action_pressed("right") \
		or Input.is_action_pressed("up") or Input.is_action_pressed("down")

	# drain only when actually using input
	if can_input and using_input:
		stamina -= stamina_drain_rate * delta
	elif not using_input:
		stamina = min(stamina + stamina_regen_rate * delta, max_stamina)

	stamina = clamp(stamina, 0.0, max_stamina)

	# input lock control
	if stamina <= 0.0:
		can_input = false
	elif stamina > stamina_threshold:
		can_input = true



		# --- Update bar (optional) ---
	if bar:
		bar.value = stamina

func _draw() -> void:
	pass

func update_array():
	arr = PackedVector2Array()
	for i in range(number_of_points):
		arr.append(Vector2(i, amplitude * sin((i / frequency) + h)))

# --- COLOR MODULATION BASED ON STAMINA ---
func _update_color_modulation() -> void:
	var stamina_value := stamina   # absolute value (0–150)

	var sat: float
	if stamina_value >= 80.0:
		sat = 1.0
	elif stamina_value <= 0.0:
		sat = 0.0
	else:
		sat = stamina_value / 80.0

	desat_material.set_shader_parameter("saturation", sat)
