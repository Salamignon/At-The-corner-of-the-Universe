extends ColorRect

signal finished

func fade(sound, time):
	show()
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(1).timeout
	if sound == "bridge":
		$bridge.play()
	if sound == "ground":
		$ground.play()
	await get_tree().create_timer(time).timeout
	$AnimationPlayer.play("fade_out")
	finished.emit()
	await $AnimationPlayer.animation_finished
	hide()


func fade_in():
	show()
	$AnimationPlayer.play("fade_in")
