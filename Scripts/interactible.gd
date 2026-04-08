extends Area2D

@export var id: String

signal talk
signal give_item()
signal pick_up
signal look_at
signal interact

func _on_button1_pressed():
	if id == "character":
		emit_signal("talk")
	if id == "item":
		emit_signal("look_at")

func _on_button2_pressed(item):
	if id == "character":
		give_item.emit(item)
	elif id == "item":
		emit_signal("pick_up")

func _on_button3_pressed():
	if id == "item":
		emit_signal("interact")
