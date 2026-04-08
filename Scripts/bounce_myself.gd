extends Sprite2D

func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.6, 0.55), 1)
	tween.tween_property(self, "scale", Vector2(0.6, 0.6), 1)
