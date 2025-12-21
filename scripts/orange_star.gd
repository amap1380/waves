extends Collectable

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	despawn_timer.start()
