extends Node2D

var game_finished: bool

func _ready() -> void:
	SaveLoad._load()
	game_finished = SaveLoad.save_data.finished_game
	mise_en_place()
	$ColorRect/AnimationPlayer.play("fade_out")
	while $AudioStreamPlayer.volume_db < -4.0:
		$AudioStreamPlayer.volume_db += 1
		await get_tree().process_frame
	$ColorRect.hide()

func _on_play_pressed() -> void:
	$ColorRect.show()
	$ColorRect/Fadetimer.start()
	$ColorRect/AnimationPlayer.play("fade_in")
	while $AudioStreamPlayer.volume_db > -80.0:
		$AudioStreamPlayer.volume_db -= 1
		await get_tree().process_frame
	global.inventory = {
	"1" : "",
	"2" : "",
	"3" : "",
	"4" : "",
	"5" : "",
	"6" : "",
}

func _on_leave_pressed() -> void:
	get_tree().quit()


func _on_fadetimer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scènes/Intro.tscn")

func mise_en_place():
	if game_finished:
		$normal.hide()
		$finished.show()
		$Play_pos.position = Vector2(-600, 0)
		$Quit_pos.position = Vector2(536, 0)
	else:
		$normal.show()
		$finished.hide()
		$Play_pos.position = Vector2(0, 0)
		$Quit_pos.position = Vector2(0, 0)
