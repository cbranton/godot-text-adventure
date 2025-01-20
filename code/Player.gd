extends Node

var inventory: Array = []

func take_item (item: Item):
	inventory.append(item)
	
func drop_item (item: Item):
	inventory.erase(item)
	
	
func get_inventory_list() -> String:
	var item_string = "You are holding "
	if inventory.size() == 0:
		item_string = "nothing."
	for item in inventory:
		item_string += item.item_name
	return item_string
