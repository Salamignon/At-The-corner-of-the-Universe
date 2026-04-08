extends Node2D

signal interacting
signal finished_interacting
signal item_to_player(item)
signal show_ticket
signal hide_ticket
signal activate_gate
signal show_books
signal player_in_abyss

var interacting_ = false
var showticket = false
var got_item1 = false
var got_item2 = false

@export var needed_item: String
@export var needed_item2: String
@export var item_to_give: String
@export var sound: String

@export var dialogue1: Array[String] = [
	""
]
@export var dialogue2: Array[String] = [
	""
]
@export var dialogue3: Array[String] = [
	""
]
@export var dialogue4: Array[String] = [
	""
]
@export var dialogue_not_for_me: Array[String] = [
	""
]

var my_items = {}


func _on_area_2d_talk() -> void:
	if !interacting_:
		if got_item1 == true:
			if my_items.has("false_ticket"):
				showticket = true
			speak(global_position, dialogue3)
		else:
			speak(global_position, dialogue1)

func _on_area_2d_give_item(given_item) -> void:
	if !interacting_:
		if given_item == needed_item:
			speak(global_position, dialogue2)
			global.erase_value(needed_item) #efface valeur
			my_items.get_or_add(needed_item)
			await finished_interacting
			if !item_to_give == "" && !needed_item == "book1":
				item_to_player.emit(item_to_give)
			if needed_item == "book1":
				show_books.emit()
			got_item1 = true
		elif given_item == needed_item2 && got_item1:
			speak(global_position, dialogue4)
			global.erase_value(needed_item2) #efface valeur
			my_items.get_or_add(needed_item2)
			await finished_interacting
			if needed_item2 == "ticket" && my_items.has("false_ticket") && my_items.has("ticket"):
				activate_gate.emit()
			if item_to_give == "contact lens":
				item_to_player.emit(item_to_give)
			got_item2 = true
		else:
			speak(global_position, dialogue_not_for_me)

func speak(position_: Vector2, lines: Array[String]):
	global.who_speaks = "normal"
	if needed_item == "talisman":
		global.who_speaks = "knight"
	if needed_item == "dreamcatcher":
		global.who_speaks = "bass"
	if needed_item == "paper":
		global.who_speaks = "spirit"
	if needed_item == "nails":
		global.who_speaks = "machine"
	if needed_item == "contact lens":
		global.who_speaks = "jack"
	if needed_item == "false_ticket":
		global.who_speaks = "ticket"
	if needed_item == "book1":
		global.who_speaks = "reader"
	
	interacting_ = true
	emit_signal("interacting")
	DialogManager.start_dialogue(position_, lines)
	if showticket:
		show_ticket.emit()
	await DialogManager.dialogue_finished
	if showticket:
		hide_ticket.emit()
	if needed_item == "nails" && my_items.has("nails") && !got_item1:
		var fade = get_node("/root/Node2D/Camera2D/Fade")
		fade.fade("bridge", 6)
		await fade.finished
		activate_gate.emit()
	if item_to_give == "nails" && !got_item1:
		item_to_player.emit("nails")
		got_item1 = true
	if needed_item == "paper" && my_items.has("paper"):
		var fade = get_node("/root/Node2D/Camera2D/Fade")
		fade.fade("ground", 9)
		await get_tree().create_timer(2).timeout
		player_in_abyss.emit()
		await fade.finished
	emit_signal("finished_interacting")
	interacting_ = false
