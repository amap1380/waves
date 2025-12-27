extends Collectable

@onready var despawn_timer: Timer = $DespawnTimer


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	despawn_timer.start()



func _on_despawn_timer_timeout() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self.sprite_2d,"scale", Vector2.ZERO, 0.4)
	tween.parallel().tween_property(self.sprite_2d,"modulate", Color(0.0, 0.0, 0.0, 0.0), 0.4)
	tween.parallel().tween_property(self.collision_shape_2d.shape,"radius", 0, 0.4)
	tween.parallel().tween_property(self.point_light_2d,"texture_scale", 0, 0.4)
	tween.tween_callback(self.queue_free)
