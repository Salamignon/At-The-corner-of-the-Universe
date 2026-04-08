extends Sprite2D

@export var id: String

func _process(_delta: float) -> void:
	show()
	if global.inventory["1"] == id:
		position.x = 350.0
	elif global.inventory["2"] == id:
		position.x = 498.0
	elif global.inventory["3"] == id:
		position.x = 661.0
	elif global.inventory["4"] == id:
		position.x = 817.0
	elif global.inventory["5"] == id:
		position.x = 977.0
	elif global.inventory["6"] == id:
		position.x = 1140.0
	else:
		hide()
