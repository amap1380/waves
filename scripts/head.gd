extends Area2D
class_name Head

signal devoured(area)

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Collectables") and area is Collectable:
		#if area.energy_level < sine_wave.energy_level:
			#self.on_head_score += 1
		#else:
			#self.mistake_score += 1
			#camera_2d.add_trauma(0.3)
		#play_devour_animation()
		#play_collected_sound()
		area.absorb()
		animation_player.play("devour")
		devoured.emit(area)
