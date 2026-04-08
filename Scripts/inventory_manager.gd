extends Node

signal return_item(item)

var item_to_give: String

func choose_item():
	return_item.emit(item_to_give)
