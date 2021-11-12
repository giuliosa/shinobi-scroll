extends ColorRect

var inventory = preload("res://Scenes/items/inventory.tres")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
