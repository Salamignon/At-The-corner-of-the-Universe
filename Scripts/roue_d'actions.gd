extends Node2D

@onready var button = $Button
@onready var button2 = $Button2
@onready var button3 = $Button3
var item_to_give: String
var area_type: String

signal button1_
signal button2_
signal button3_
signal item_choosed

func _on_area_box_area_entered(area: Area2D) -> void:
	area_type = area.id
	global.area_target_pos = area.global_position
	if area.id == "character":
		button.set_text("Talk")
		button2.set_text("Give item")
		button3.set_text("") 
	elif area.id == "item":
		button.set_text("Look at")
		button2.set_text("Pick up")
		button3.set_text("Interact")
	
	button1_.connect(area._on_button1_pressed)
	button2_.connect(area._on_button2_pressed)
	button3_.connect(area._on_button3_pressed)

func _on_area_box_area_exited(area: Area2D) -> void:
	button1_.disconnect(area._on_button1_pressed)
	button2_.disconnect(area._on_button2_pressed)
	button3_.disconnect(area._on_button3_pressed)

func _on_button_pressed() -> void:
	emit_signal("button1_")

func _on_button_2_pressed() -> void:
	if area_type == "character":
		item_to_give = ""
		global.interacting = true
		global.inventory_choosing = true
		global.inventory_on = true
		await item_choosed
		if item_to_give == "":
			return
		button2_.emit(item_to_give)
		global.inventory_choosing = false
		global.inventory_on = false
	elif area_type == "item":
		button2_.emit(null)

func _on_button_3_pressed() -> void:
	emit_signal("button3_")


func _on_character_body_2d_give_to_action(item) -> void:
	item_to_give = item
	item_choosed.emit()


func _on_character_body_2d_stop_inventory_choosing() -> void:
	global.inventory_choosing = false
	global.inventory_on = false
	item_choosed.emit()
