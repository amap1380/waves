extends Node2D
class_name SineWave

@onready var body: Line2D = $Body
@onready var spikes: Line2D = $Spikes
@onready var head: Head = $Head


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

#@export var gradient_1: Gradient
#@export var gradient_2: Gradient
#@export var gradient_3: Gradient

func _ready() -> void:
	update_array()
	queue_redraw()

var ratio = 0.1

@onready var collison_polygone : Array[PackedVector2Array]
var arr = PackedVector2Array()

var color: Color
var energy_level := 0


func _physics_process(delta: float) -> void:
	
	ratio += Input.get_axis("left", "right")*delta * speed / 5.0
	ratio = clampf(ratio, 0.0, 1.0)
	number_of_points = int(lerp(100.0, get_viewport_rect().size.x - 100.0, ratio))
	#amplitude = lerpf(200.0, 0.0 , ratio)
	amplitude += Input.get_axis("down", "up") * delta * speed * 100.0
	amplitude = clampf(amplitude, 0.0, 200.0)
	frequency = lerpf(50.0, 200.0, ratio)
	h += delta * sine_speed
	wrapf(h,0, TAU)
	
	#var energy = abs(amplitude)/200.0 * (1.0 - ratio)
	# energy ranges
	#if energy <= 0.3:
		#energy_level = 1
		#color = Color("30bf7fff")
		#body.gradient = gradient_1
	#elif energy > 0.3 and energy < 0.6:
		#energy_level = 2
		#color = Color("b630bfff")
		#body.gradient = gradient_2
	#elif energy >= 0.6:
		#energy_level = 3
		#color = Color("3078bfff")
		#body.gradient = gradient_3
	#else:
		#energy_level = 0
		#color = Color.RED
		#body.gradient = null
	##self.modulate = color
	#body.self_modulate = color * 2.0
	update_array()
	body.points = arr
	spikes.points = arr
	head.global_position =  arr[-2] + global_position
	head.look_at(arr[-1] + global_position)
	queue_redraw()

func _draw() -> void:
	pass
	#draw_polyline(arr, color, 8.0, true)



func update_array():
	arr = PackedVector2Array()
	for i in range(number_of_points):
		arr.append(Vector2(
			i,
			amplitude * sin((i / frequency) + h))
		)
