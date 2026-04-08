extends Button

var mouse_on: bool = false

signal item_to_player(item)

func _process(_delta: float) -> void:
	if mouse_on && Input.is_action_pressed("set_target"):
		item_to_player.emit("ticket")
		queue_free()

func _on_mouse_entered() -> void:
	mouse_on = true

func _on_ticket_guy_hide_ticket() -> void:
	hide()

func _on_ticket_guy_show_ticket() -> void:
	show()


func _on_mouse_exited() -> void:
	mouse_on = false
