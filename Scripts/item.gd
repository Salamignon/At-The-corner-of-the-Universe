extends Node2D

@export var item_type: String
@export var look: Array[String]= [
	""
]
@export var interact_text: Array[String] = [
	""
]
@export var pickup_text: Array[String] = [
	""
]

var interacting_ = false
var picked_up = false

signal item_to_player(item)
signal interacting
signal finished_interacting

func _on_area_2d_pick_up() -> void:
	if !picked_up && !item_type == "crystal orb":
		picked_up = true
		item_to_player.emit(item_type)
		queue_free()
	elif item_type == "crystal orb":
		speak(global_position, pickup_text)

func _on_area_2d_look_at() -> void:
	speak(global_position, look)

func _on_area_2d_interact() -> void:
	if !item_type == "crystal orb":
		speak(global_position, interact_text)
		return
	else:
		global.is_orange_on = !global.is_orange_on
		$AudioStreamPlayer2.play()
		$AudioStreamPlayer.play()


func speak(position_: Vector2, lines: Array[String]):
	global.who_speaks = "item"
	interacting_ = true
	emit_signal("interacting")
	DialogManager.start_dialogue(position_, lines)
	await DialogManager.dialogue_finished
	await get_tree().create_timer(0.5).timeout
	emit_signal("finished_interacting")
	interacting_ = false
	


func _process(_delta: float) -> void:
	if !item_type == "crystal orb":
		return
	if global.is_orange_on:
		$orange.show()
		$blue.hide()
	else:
		$orange.hide()
		$blue.show()
