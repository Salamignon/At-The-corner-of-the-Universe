extends Node2D

@onready var area = $Area2D
@export var point1: Vector2
@export var point2: Vector2
@export var can_move = true
var is_moving = false
var current_target: Vector2
@export var speed = 50
@export var one_shot = false
signal finished_moving


func _ready() -> void:
	current_target = point2

func moveto(dir, delta):
	$AudioStreamPlayer.play()
	is_moving = true
	while global_position.distance_squared_to(current_target) > 1.0:
		global_position += dir * speed * delta
		global.platform_dir = dir
		global.platform_speed = speed
		await get_tree().process_frame
	current_target = (
		point1 if current_target == point2 else point2
		)
	if one_shot:
		can_move = false
	finished_moving.emit()
	is_moving = false
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer2.play()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !can_move:
		return
	var dir: Vector2 = global_position.direction_to(current_target)
	var delta = get_process_delta_time()
	if !is_moving:
		global.can_move = false
		global.interacting = true
		global.player_on_platform = true
		moveto(dir, delta)
		await finished_moving
		global.can_move = true
		global.interacting = false
		global.player_on_platform = false
	else:
			return
