extends Node2D

signal activate_player

func _ready():
	$Camera2D/Fade/AnimationPlayer.play("fade_out")
	await $Camera2D/Fade/AnimationPlayer.animation_finished
	$Inventory.show()
	$Camera2D/Fade.hide()
	while $Ingame_music.volume_db < -9.0:
		$Ingame_music.volume_db += 1
		await get_tree().process_frame
	activate_player.emit()

func _process(delta: float) -> void:
	if global.player_on_platform:
		$"objets triés y/Player".global_position += global.platform_dir * global.platform_speed * delta
	
	if $Camera2D.global_position.y - 50 < $PointLight2D.global_position.y:
		$PointLight2D.hide()
	else:
		$PointLight2D.show()


func _on_transition_body_entered(_body: Node2D) -> void:
	$Camera2D/Fade.fade("", 2)
	global.can_move = false
	await get_tree().create_timer(1).timeout
	$"objets triés y/Player".position = Vector2(2600, 100)
	$"objets triés y/Player/NavigationAgent2D".target_reached.emit()
	$EntreeTempleBack.hide()
	$feuilles27.hide()
	$"objets triés y/EntreeTempleFront".hide()
	await get_tree().create_timer(3).timeout
	global.can_move = true

func _on_transition_2_body_entered(_body: Node2D) -> void:
	$Inventory.hide()
	$Camera2D/Fade.fade_in()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scènes/final_scene.scn")

func _on_trapped_spirits_player_in_abyss() -> void:
	$"objets triés y/Player".position = Vector2(15450, 575)


func _on_reader_show_books() -> void:
	$"objets triés y/Languages".process_mode = Node.PROCESS_MODE_ALWAYS
	$"objets triés y/Languages".show()
	$"objets triés y/Nymph book".process_mode = Node.PROCESS_MODE_ALWAYS
	$"objets triés y/Nymph book".show()


func _on_robot_activate_gate() -> void:
	$"objets fixes/pont".show()
	$"régions de navigation/bridge".enabled = true
	$"régions de navigation/bridge".bake_navigation_polygon()


func _on_zone_1_body_entered(_body: Node2D) -> void:
	global.surface_footstep = 1

func _on_zone_2_body_entered(_body: Node2D) -> void:
	global.surface_footstep = 2


func _on_zone_3_body_entered(_body: Node2D) -> void:
	global.surface_footstep = 3
	$Ingame_music.stop()
	$Abyss_sound.play()


func _on_ticket_guy_activate_gate() -> void:
	$transition/CollisionShape2D.disabled = false
