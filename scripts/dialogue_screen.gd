extends PanelContainer
@onready var label: Label = $VBoxContainer/CenterContainer/Label
@onready var enter_label: Label = $VBoxContainer/EnterLabel

@export var typing_speed: float = 32.0

var dialogue: Dialogue
var current_line: int = 0


func _ready() -> void:
	#loads the current level dialogue from dialogues folder
	if not ResourceLoader.exists("res://resources/dialogues/%d.tres" % LevelManager.current_level):
		SceneManager.change_scene(self,"res://scenes/main.tscn", false)
		return
	dialogue = ResourceLoader.load("res://resources/dialogues/%d.tres" % LevelManager.current_level)
	if dialogue.dialogue_lines.is_empty():
		SceneManager.change_scene(self, "res://scenes/main.tscn", false)
		return
	#sets the label text and hides it
	label.text = dialogue.dialogue_lines[current_line]
	label.visible_ratio = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
		or (event is InputEventMouseButton and event.button_index == 1)):
		if label.visible_ratio < 1.0:
			#shows the current line
			label.visible_ratio = 1.0
		else:
			#progress the dialogue lines
			update_current_line(current_line + 1)

func _process(delta: float) -> void:
	animate_typing(delta)

func animate_typing(delta: float) -> void:
	if label.visible_ratio >= 1.0:
		return
	label.visible_ratio += delta * typing_speed / label.get_total_character_count()

func update_current_line(value: int):
	if value >= dialogue.dialogue_lines.size():
		SceneManager.change_scene(self,"res://scenes/main.tscn")
		
	else:
		current_line = value
		label.text = dialogue.dialogue_lines[current_line]
		label.visible_ratio = 0.0
