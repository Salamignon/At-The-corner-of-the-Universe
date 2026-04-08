extends Sprite2D

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(0, -10), 1)
	tween.tween_property(self, "position", Vector2(0, 0), 1)
