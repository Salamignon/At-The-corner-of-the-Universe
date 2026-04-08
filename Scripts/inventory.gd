extends CanvasLayer

@onready var buttons = $Control
@onready var ferme = $"fermé"
@onready var ouvert = $ouvert
var item_to_give: String

signal interacting
signal finished_interacting
signal give_item()
signal close_choosing

func _process(_delta: float) -> void:
	if global.inventory_on:
		buttons.show()
		ouvert.show()
		ferme.hide()
		$Lineferme.hide()
		$Lineouvert.show()
	else:
		buttons.hide()
		ouvert.hide()
		ferme.show()
		$Lineferme.show()
		$Lineouvert.hide()



func _on_texture_button_pressed() -> void:
	if !global.inventory_choosing:
		if global.inventory_on && !global.player_in_link && global.interacting:
			finished_interacting.emit()
			global.inventory_on = false
			$closesound.play()
		elif !global.interacting && !global.player_in_link && !global.inventory_on:
			interacting.emit()
			global.inventory_on = true
			$opensound.play()
	elif global.inventory_choosing:
		global.inventory_choosing = false
		close_choosing.emit()
		finished_interacting.emit()
		$closesound.play()

func _on_texture_button_mouse_entered() -> void:
	global.can_move = false
func _on_texture_button_mouse_exited() -> void:
	if !global.interacting && !global.inventory_choosing:
		global.can_move = true


func _on_player_new_item() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	$newitem.play()
	tween.tween_property(ferme, "modulate", Color(1.0, 1.0, 1.0, 0.38), 0.25) 
	tween.tween_property(ferme, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25) 


func _on_button_pressed() -> void:
	if !global.inventory["1"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["1"]
		give_item.emit(item_to_give)

func _on_button_2_pressed() -> void:
	if !global.inventory["2"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["2"]
		give_item.emit(item_to_give)

func _on_button_3_pressed() -> void:
	if !global.inventory["3"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["3"]
		give_item.emit(item_to_give)

func _on_button_4_pressed() -> void:
	if !global.inventory["4"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["4"]
		give_item.emit(item_to_give)

func _on_button_5_pressed() -> void:
	if !global.inventory["5"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["5"]
		give_item.emit(item_to_give)

func _on_button_6_pressed() -> void:
	if !global.inventory["5"] == "" && global.inventory_choosing:
		item_to_give = global.inventory["6"]
		give_item.emit(item_to_give)
