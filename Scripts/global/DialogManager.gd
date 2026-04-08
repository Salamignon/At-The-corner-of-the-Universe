extends Node

@onready var text_box_scene = preload("res://Scènes/TextBox.scn")

var dialogue_lines: Array[String] = []
var current_line_index = 0

var text_box
var text_box_position: Vector2
var is_dialogue_active = false
var can_advance_line = false
var line_finished_displaying = false

signal dialogue_finished

func start_dialogue(position: Vector2, lines: Array[String]):
	if is_dialogue_active: #ne s'active pas quand le dialogue est actif
		return
	
	dialogue_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialogue_active = true

func end_dialogue(): #indique que le dialogue est fini
	dialogue_finished.emit()


func _show_text_box():
	line_finished_displaying = false
	text_box = text_box_scene.instantiate() #créé une instyance de text_box
	text_box.finished_displaying.connect(_on_text_box_finished_displaying) #se connecte au meesage de la textbox
	get_tree().root.add_child(text_box) #rajoute l'instance de text box
	text_box.global_position = text_box_position #place le text box
	text_box.display_text(dialogue_lines[current_line_index]) #affiche le texte de la text box
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true
	line_finished_displaying = true

func _unhandled_input(event):
	if is_dialogue_active && (event.is_action_pressed("skip") or event.is_action_pressed("set_target")): #si on skip le dialogue
		if line_finished_displaying:
			text_box.queue_free() #on détruit la text box
			current_line_index += 1 #on saute une ligne
			if current_line_index >= dialogue_lines.size(): #si on a finit, on enlève tout et on signale
				is_dialogue_active = false
				current_line_index = 0 
				end_dialogue()
				return
		else:
			return
		
		_show_text_box()
