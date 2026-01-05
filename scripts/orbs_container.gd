extends HBoxContainer

var positive_index:int = 0
var negetive_index:int = -1

func set_positive(value: int) -> void:
	if positive_index >= get_child_count():
		return
	var orb:OrbsUI = get_child(positive_index)
	if value > orb.max_value * (positive_index + 1):
		positive_index += 1
		set_positive(value - int(orb.max_value) * (positive_index))
	else:
		orb.value = value

func set_negetive(value: int) -> void:
	if abs(negetive_index) > get_child_count():
		return
	var orb:OrbsUI = get_child(negetive_index)
	if value > orb.negetive_bar.max_value * abs(negetive_index):
		negetive_index -= 1
		set_positive(value - int(orb.negetive_bar.max_value) * (negetive_index))
	else:
		orb.negetive_bar.value = value
