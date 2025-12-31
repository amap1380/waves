@tool
extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect


const MINUTES_PER_HOUR = 60
const HOURS_PER_DAY = 24
const MINUTES_PER_DAY = MINUTES_PER_HOUR * HOURS_PER_DAY
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY


var time:float= 0.0
var past_minute:int= -1

var finish_line: Node2D
var init_pos_x: float

@export var gradient:Gradient
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR


func _ready() -> void:
	if Engine.is_editor_hint():
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR
		var value = (sin(time - PI / 2.0) + 1.0) / 2.0
		color_rect.material.set("shader_parameter/blend_color", gradient.sample(value))


func _process(_delta: float) -> void:
	var value: float
	if Engine.is_editor_hint():
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR
		value = (sin(time - PI / 2.0) + 1.0) / 2.0
	else:
		value = finish_line.global_position.x / init_pos_x
	color_rect.material.set("shader_parameter/blend_color", gradient.sample(value))
