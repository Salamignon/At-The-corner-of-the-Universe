extends Node2D

var line_to_read = 1

func _ready():
	$texte.text = "Some legends say that, at the four corners of our world, reality merges into one and unique place."
	$Fade.show()
	await get_tree().create_timer(2).timeout
	$AudioStreamPlayer.play()
	$Fade/AnimationPlayer.play("fade_out")
	await $Fade/AnimationPlayer.animation_finished
	$Fade.hide()
	$Timer.start()


func _on_timer_timeout() -> void:
	line_to_read += 1
	$Fade.show()
	$Fade/AnimationPlayer.play("fade_in")
	await $Fade/AnimationPlayer.animation_finished
	if line_to_read == 2:
		$texte.text = "A gigantic temple where people from all parts of the world can meet."
		$carte.hide()
		$temple.show()
	elif line_to_read == 3:
		$texte.text = "Some even say that there is a creature that lives in this temple. A nymph capable of fulfilling every wish that we can
		think of."
		$temple.hide()
		$nymphe.show()
	elif line_to_read == 4:
		$texte.text = "This is you. You are Ellen, an inhabitant of this world who decided to explore the corner of the world to find the nymph."
		$nymphe.hide()
		$joueur.show()
	elif line_to_read == 5:
		end_it()
		return
	$Fade/AnimationPlayer.play("fade_out")
	await $Fade/AnimationPlayer.animation_finished
	$Fade.hide()
	$Timer.start()

func end_it():
	$Label.show()
	await get_tree().create_timer(5).timeout
	$Label.hide()
	while $AudioStreamPlayer.volume_db > -80.0:
		$AudioStreamPlayer.volume_db -= 1
		await get_tree().process_frame
	get_tree().change_scene_to_file("res://Scènes/Monde_principal.scn")
