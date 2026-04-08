extends Node2D

signal finished_talking

var text: Array[String] = [
	"Welcome, my child",
	"I was aware of your visit to my lair",
	"Now, tell me your strongest desire",
	"... I see...",
	"So you want to break free from your bound that ties you to this world?",
	"Well, say no more and watch your wish come true."
]

var footstep = 0


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	while footstep < 5:
		$footstep_abyss.play()
		footstep+= 1
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(1).timeout
	$AudioStreamPlayer.play()
	$AudioStreamPlayer2.play()
	$AnimationPlayer.play("raise arms")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	speak($text_pos.position, text)
	await finished_talking
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("light_up")
	await $AnimationPlayer.animation_finished
	$Abyss_sound.stop()
	$AnimationPlayer.play("RESET")
	SaveLoad.save_data.finished_game = true
	SaveLoad._save()
	$VideoStreamPlayer.play()
	await $VideoStreamPlayer.finished
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scènes/Main_Menu.scn")


func speak(position_: Vector2, lines: Array[String]):
	global.who_speaks = "nymph"
	DialogManager.start_dialogue(position_, lines)
	await DialogManager.dialogue_finished
	await get_tree().create_timer(0.5).timeout
	finished_talking.emit()
