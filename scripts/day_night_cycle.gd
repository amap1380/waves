@tool
extends CanvasModulate

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



func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR
		var value = (sin(time - PI / 2.0) + 1.0) / 2.0
		self.color = gradient.sample(value)
	else:
		self.color = gradient.sample(
		finish_line.global_position.x / init_pos_x)
	
