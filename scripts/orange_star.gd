extends Collectable

@onready var despawn_timer: Timer = $DespawnTimer


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	super._on_visible_on_screen_notifier_2d_screen_entered()
	despawn_timer.start()



func _on_despawn_timer_timeout() -> void:
	super._despawn()
