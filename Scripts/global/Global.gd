extends Node
#variables qui peuvent être utilisées depuis partout
var inventory = {
	"1" : "",
	"2" : "",
	"3" : "",
	"4" : "",
	"5" : "",
	"6" : "",
}
var inventory_on = false
var interacting = false
var can_move = true
var player_in_link = false
var area_target_pos: Vector2
var inventory_choosing = false

var is_orange_on = true
var player_on_platform = false
var platform_dir: Vector2
var platform_speed = 50
var who_speaks: String = ""

var surface_footstep = 1

func erase_value(value):
	for key in inventory:
		if inventory[key] == value:
			inventory[key] = ""
			return
