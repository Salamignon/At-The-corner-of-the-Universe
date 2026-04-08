extends CharacterBody2D

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var roue_actions = $"Roue d'actions"
@onready var ap = $AnimationPlayer

var speed: int = 13
var link_exit_pos: Vector2
var in_link = false
var moving = false

signal new_item
signal give_to_action()
signal stop_inventory_choosing

func _ready() -> void:
	hide()
	roue_actions.hide()
	set_physics_process(false)

func _on_node_2d_activate_player() -> void:
	show()
	ap.play("slide")
	await ap.animation_finished
	ap.play("jump")
	await ap.animation_finished
	set_physics_process(true)

func _physics_process(_delta: float) -> void:

	var area_box = %AreaBox.get_overlapping_areas()
	if area_box.size() < 1 or global.interacting or global.inventory_choosing:
		roue_actions.hide()
	else:
		roue_actions.show()
	
	if global.can_move:
		set_navigation()
		navigate()
	elif global.interacting:
		nav_agent.velocity = Vector2(0, 0)
		nav_agent.target_position = global_position
		
	if global_position.distance_to(link_exit_pos) <= 25:
		in_link = false
		global.player_in_link = false
	animate()
	play_sounds()
	
	if nav_agent.is_navigation_finished():
		moving = false
	


func set_navigation() -> void:
	if Input.is_action_just_pressed("set_target"): #si on clique
		nav_agent.target_position = get_global_mouse_position() #place le point d'arrivée



func navigate() -> void:
	if nav_agent.is_navigation_finished():
		return #si trajet finit, stop
	var next_path_pos: Vector2 = nav_agent.get_next_path_position() #cherche le prochain point
	var new_velocity: Vector2 = global_position.direction_to(next_path_pos) * speed #définit vélocité
	nav_agent.velocity = new_velocity #se déplace
	moving = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	position += safe_velocity * get_physics_process_delta_time() * speed#esquive les obstacles

func _on_navigation_agent_2d_target_reached() -> void:
	nav_agent.velocity = Vector2(0, 0)
	nav_agent.target_position = global_position
 

func _on_timer_path_timeout() -> void: #le timer met à jour la cible (0.1s) pour avoir un mouvement fluide
	if !nav_agent.is_navigation_finished() && !in_link: #uniquement si on bouge et pas dans un lien
		nav_agent.target_position = nav_agent.target_position
	else:
		return


func _on_item_item_to_player(item) -> void:
	if global.inventory["1"] == "":
		global.inventory["1"] = item
	elif global.inventory["2"] == "":
		global.inventory["2"] = item
	elif global.inventory["3"] == "":
		global.inventory["3"] = item
	elif global.inventory["4"] == "":
		global.inventory["4"] = item
	elif global.inventory["5"] == "":
		global.inventory["5"] = item
	elif global.inventory["6"] == "":
		global.inventory["6"] = item
	new_item.emit()
	print(global.inventory)
#donne un objet au joueur


func animate():
	if !moving && !global.interacting:
		if get_global_mouse_position().x > position.x + 100: 
			ap.play("idle_right")
		elif get_global_mouse_position().x < position.x - 100:
			ap.play("idle_left")
		else:
			ap.play("idle")
	elif moving:
		if nav_agent.get_next_path_position() > global_position:
			ap.play("walking_right")
		else:
			ap.play("walking_left")
	elif global.interacting:
		if global.area_target_pos.x > position.x + 100: 
			ap.play("idle_right")
		elif global.area_target_pos.x < position.x - 100:
			ap.play("idle_left")
		else:
			ap.play("idle")


func play_sounds():
	if ap.current_animation == "walking_left" or ap.current_animation == "walking_right":
			if $Sprite2D.frame == 3 or $Sprite2D.frame == 6:
				if global.surface_footstep == 1:
					$footstep_grass.play()
				elif global.surface_footstep == 2:
					$footstep_stone.play()
				elif global.surface_footstep == 3:
					$footstep_abyss.play()


func _on_node_2d_interacting() -> void: #indique qu'il intéragit
	global.can_move = false
	global.interacting = true
	moving = false

func _on_node_2d_finished_interacting() -> void: #indique qu'il n'intéragit plus
	global.can_move = true
	global.interacting = false
	moving = true


func _on_navigation_agent_2d_link_reached(details: Dictionary) -> void:
	in_link = true
	global.player_in_link = true
	link_exit_pos = details["link_exit_position"]


func _on_button_mouse_entered() -> void:
	global.can_move = false
func _on_button_mouse_exited() -> void:
	if !global.interacting && !global.inventory_choosing:
		global.can_move = true


func _on_inventory_give_item(item) -> void:
	give_to_action.emit(item)

func _on_inventory_close_choosing() -> void:
	stop_inventory_choosing.emit()
