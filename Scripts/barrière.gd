extends Node2D

@export var is_color_orange: bool

func _ready() -> void:
	$"orange_levé".hide()

func _process(_delta: float) -> void:
	if is_color_orange:
		if global.is_orange_on:
			$NavigationObstacle2D.avoidance_enabled = true
			$"orange_levé".show()
			$"orange_baissé".hide()
			
		else:
			$NavigationObstacle2D.avoidance_enabled = false
			$"orange_levé".hide()
			$"orange_baissé".show()
	else:
		if global.is_orange_on:
			$NavigationObstacle2D.avoidance_enabled = false
			$"bleu_levé".hide()
			$"bleu_baissé".show()
		else:
			$NavigationObstacle2D.avoidance_enabled = true
			$"bleu_levé".show()
			$"bleu_baissé".hide()
