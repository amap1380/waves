extends HBoxContainer

var positive_index:int = 0
var negetive_index:int = -1

func reset_orbs() -> void:
	for orb in get_children():
		orb.value = 0
		orb.negetive_value = 0

func set_positive(value: int) -> void:
	#print('postive %d' % value)
	if positive_index >= get_child_count():
		return
	var orb:OrbsUI = get_child(positive_index)
	if value > orb.max_value * (positive_index + 1):
		positive_index += 1
		set_positive(value - int(orb.max_value) * (positive_index))
	else:
		#print('postive final %d' % value)
		orb.value = value

func set_negetive(value: int) -> void:
	if abs(negetive_index) > get_child_count():
		return
	var orb:OrbsUI = get_child(negetive_index)
	if value > orb.negetive_bar.max_value * abs(negetive_index):
		negetive_index -= 1
		set_negetive(value - int(orb.negetive_bar.max_value) * abs(negetive_index + 1))
	else:
		#print('negetive final %d' % value)
		orb.negetive_value = value

func test_positive(value: int) -> void:
	var test_index:int = 0
	while test_index < get_child_count():
		#print('postive %d, index %d' % [value, test_index])
		var orb: OrbsUI = get_child(test_index)
		if value > orb.max_value:
			orb.value = orb.max_value
			value -= int(orb.max_value)
			test_index += 1
			continue
		else:
			orb.value = value
			break

func test_negetive(value: int) -> void:
	var test_index:int = -1
	while abs(test_index) <= get_child_count():
		#print('negetive %d, index %d' % [value, test_index])
		var orb: OrbsUI = get_child(test_index)
		if value > orb.negetive_max_value:
			orb.negetive_value = orb.negetive_max_value
			value -= int(orb.negetive_max_value)
			test_index -= 1
			continue
		else:
			orb.negetive_value = value
			break
