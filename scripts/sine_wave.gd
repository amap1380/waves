extends Node2D
class_name SineWave

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

@export var number_of_points = 1000:
	set(value):
		if number_of_points != value:
			number_of_points = value
			queue_redraw()

func _ready() -> void:
	queue_redraw()

var ratio = 0.0

@onready var collison_polygone : Array[PackedVector2Array]
var arr = PackedVector2Array()


func _physics_process(delta: float) -> void:
	
	ratio += Input.get_axis("left", "right")*delta * speed / 5.0
	ratio = clampf(ratio, 0.0, 1.0)
	number_of_points = int(lerp(100.0, get_viewport_rect().size.x - 200.0, ratio))
	#amplitude = lerpf(200.0, 0.0 , ratio)
	amplitude += Input.get_axis("down", "up") * delta * speed * 100.0
	amplitude = clampf(amplitude, -200.0, 200.0)
	frequency = lerpf(50.0, 200.0, ratio)
	h += delta * 2
	wrapf(h,0, TAU)
	update_array()
	queue_redraw()

func _draw() -> void:
	draw_polyline(arr, Color.SLATE_BLUE, 2.0, true)


func update_array():
	arr = PackedVector2Array()
	for i in range(number_of_points):
		arr.append(Vector2(
			i,
			amplitude * sin((i / frequency) + h))
		)

func update_collision():
	pass
