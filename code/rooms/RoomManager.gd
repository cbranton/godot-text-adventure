extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	$HouseRoom.connect_exit_unlocked("east", $FrontPorch)
	
	var locked_exit = $FrontPorch.connect_exit_locked("north", $ShedRoom)
	
	var key = load_item_resource("key")
	key.use_value = locked_exit	
	$FrontPorch.add_item(key)
	
	var potion = load_item_resource("potion")
	$ShedRoom.add_item(potion)

	var monster = load_npc_resource("monster")
	$ShedRoom.add_npc(monster)
	monster.quest_reward = "mmmm!"
	
func load_item_resource(item_name):
	return load ("res://items/" + item_name + ".tres")
	
func load_npc_resource(npc):
	return load ("res://npc/" + npc + ".tres")
	
