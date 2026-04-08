extends Area2D

@export var pos: Vector2
@export var change_cam_size = false

func _on_body_entered(_body: Node2D) -> void:
	var camera = get_node("/root/Node2D/Camera2D") #obtient le spropritétés de la caméra
	var tween = create_tween() #créé un tween
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT) #met un ease_in et un ease_out
	tween.tween_property(camera, "position", pos, 1.5) #lance le tween sur la position de la caméra
	if change_cam_size:
		tween.tween_property(camera, "zoom", Vector2(0.65, 0.65), 0.5) #lance le tween sur la taille de la caméra
	else:
		tween.tween_property(camera, "zoom", Vector2(1, 1), 0.5)
