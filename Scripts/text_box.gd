extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 600

var text = ""
var letter_index = 0

var letter_time = 0.06
var space_time = 0.06
var punctuation_time = 0.2
var sound_: String = ""

signal finished_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	label.text = text_to_display
	await get_tree().process_frame
	custom_minimum_size = label.size
	
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 300
	label.visible_characters = 0
	_display_letter()


func _display_letter(): 
	label.visible_characters += 1 #rajoute lettre
	letter_index += 1 #avance à la prochaine lettre
	if global.who_speaks == "normal":
		$talk_normal.play()
	elif global.who_speaks == "knight":
		$talk_knight.play()
	elif global.who_speaks == "bass":
		$talk_knight_bass.play()
	elif global.who_speaks == "spirit":
		$talk_spirit.play()
	elif global.who_speaks == "machine":
		$talk_machine.play()
	elif global.who_speaks == "item":
		$talk_item.play()
	elif global.who_speaks == "jack":
		$talk_jack.play()
	elif global.who_speaks == "ticket":
		$talk_ticket.play()
	elif global.who_speaks == "nymph":
		$talk_nymph.play()
	elif global.who_speaks == "reader":
		$talk_reader.play()
	
	if letter_index >= text.length():
		finished_displaying.emit()
		return #envoie signal pour dire que finit d'écrire
	
	match text[letter_index]: #choisit le temps d'attente selon le caractère
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter() #envoie le signal de display letter à intervalle définie
