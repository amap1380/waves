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

@export var number_of_points:int = 1000:
	set(value):
		if number_of_points != value:
			number_of_points = value
			queue_redraw()


var inputs = {
	"up":true,
	"down":true,
	"right":true,
	"left":true
}

var ratio = 0.1

var arr = PackedVector2Array()

var color: Color

func _ready() -> void:
	update_array()
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		pass

var transition_flag = true

func _physics_process(delta: float) -> void:
	#dirt flag can use another design pattern
	if transition_flag:
		ratio += Input.get_action_strength("right") * delta * speed / 5.0 * float(inputs["right"])
		ratio -= Input.get_action_strength("left") * delta * speed / 5.0 * float(inputs["left"])
		ratio = clampf(ratio, 0.0, 1.0)
		number_of_points = int(lerp(100.0, get_viewport_rect().size.x - 100.0, ratio))
	#amplitude = lerpf(200.0, 0.0 , ratio)
		amplitude += Input.get_action_strength("up") * delta * speed * 100.0 * float(inputs["up"])
		amplitude -= Input.get_action_strength("down") * delta * speed * 100.0 * float(inputs["down"])
		amplitude = clampf(amplitude, 0.0, 200.0)
		frequency = lerpf(50.0, 200.0, ratio)
		h += delta * sine_speed
		wrapf(h,0, TAU)
		
		update_array()
	body.points = arr
	spikes.points = arr
	head.global_position =  arr[-2] + global_position
	head.look_at(arr[-1] + global_position)
	queue_redraw()

var target: Vector2
var elapsed_time = 0
func _process(delta: float) -> void:
	if not transition_flag:
		for i in number_of_points:
			arr[number_of_points - 1 - i].y = Tween.interpolate_value(
				arr[number_of_points - 1 - i].y, 
				-arr[number_of_points - 1 - i].y + (self.global_position.y + 500) * target.y,
				elapsed_time, Constants.SINE_WAVE_TRANSITION_TIME + (i* delta), 
				Tween.TRANS_QUAD if target.y != 0 else Tween.TRANS_LINEAR, Tween.EASE_IN)
			arr[number_of_points - 1 - i].x = Tween.interpolate_value(
				arr[number_of_points - 1 - i].x, 
				get_viewport_rect().size.x - arr[number_of_points - 1 - i].x + 100 * target.x,
				elapsed_time, Constants.SINE_WAVE_TRANSITION_TIME + (i* delta),
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		elapsed_time = min(elapsed_time+delta, Constants.SINE_WAVE_TRANSITION_TIME)

func _draw() -> void:
	pass
	#draw_polyline(arr, color, 8.0, true)

func ascend():
	transition_flag = false
	head.collision_shape_2d.disabled = true
	target = Vector2(-1,-1)

func descend():
	transition_flag = false
	head.collision_shape_2d.disabled = true
	target = Vector2(-1,1)

func stay():
	transition_flag = false
	head.collision_shape_2d.disabled = true
	target = Vector2.RIGHT

func set_input(input: String, enable: bool):
	if inputs.has(input):
		inputs[input] = enable
	else :
		push_error("input %s not found" % input )

func update_array():
	arr = PackedVector2Array()
	for i in number_of_points:
		arr.append(Vector2(
			i,
			amplitude * sin((i / frequency) + h))
		)
