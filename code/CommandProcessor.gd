extends Node

signal response_generated (response_text)
signal room_changed (new_room)

var current_room = null
var player = null

func initialize(starting_room, player_character) -> String:
	self.player = player_character
	return change_room(starting_room)
	

func process_command(input: String) -> String:
	var words = input.split(" ", false)
	if words.size() == 0:
		return "I don't think you typed anything."
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	match first_word:
		"go": 
			return go(second_word)
		"take":
			return take(second_word)
		"drop":
			return drop(second_word)
		"inventory":
			return inventory()
		"use":
			return use(second_word)
		"talk":
			return talk(second_word)
		"give":
			return give (second_word)
		"help":
			return help()
		"quit":
			get_tree().quit()
			return ("Quitting")
		_: 
			return Types.wrap_error_text("I did not understand %s" %first_word)
		
func take(item_name: String) -> String:
	if item_name == "":
		return Types.wrap_text("What did you want to take?", Types.COLOR_SYSTEM)
		
	for item in current_room.items:
		if item_name.to_lower() == item.item_name.to_lower():
			player.take_item(item)
			current_room.remove_item(item)
			return "You take the " + item_name + "."
			
	return "There is no " + item_name + " here."


func drop(item_name: String) -> String:
	if item_name == "":
		return "What did you want to drop?"
		
	for item in player.inventory:
		if item_name.to_lower() == item.item_name.to_lower():
			player.drop_item(item)
			current_room.add_item(item)
			return "You drop the " + item_name + "."
			
	return "You have no " + item_name + "."
		
		
func inventory() -> String:
	return player.get_inventory_list()
			
func go (direction: String) -> String:
	if direction == "":
		return "Where did you want to go?"
		
	if current_room.exits.keys().has(direction):
		var exit = current_room.exits[direction]
		if exit.is_locked:
			return "It's locked."
			
		var response_text = "\n".join(["You go %s" % direction, change_room(exit.get_destination_room(current_room))])
		return response_text
	else:
		return "You cannot go that way."
	
func use(item_name: String) -> String:
	if item_name == "":
		return "What did you want to use?"
	
	for item in player.inventory:
		if item_name.to_lower() == item.item_name.to_lower():
			match item.item_type:
				Types.ItemTypes.KEY:
					for exit in current_room.exits.values():
						if exit == item.use_value:
							exit.is_locked = false
							player.drop_item(item)
							return "You use your %s to unlock the %s." % [item_name, exit.get_destination_room(current_room).room_name]
					return "You can't use that here."
				_: 
					return "Invalid item type " + item.item_type
	return "You do not have the " + item_name +"."
	
	
func talk(character: String) -> String:
	if character == "":
		return "Who did you want to talk to?"
	for npc in current_room.npcs:
		if npc.npc_name.to_lower() == character.to_lower():
			var dialog = npc.post_quest_dialog if npc.has_quest_item else npc.initial_dialog
			return dialog
	return "There is no one here by that name."
	
	
func give(item_name: String) -> String:
	if item_name == "":
		return "What did you want to give?"
	
	var has_item := false
	for item in player.inventory:
		if item_name.to_lower() == item.item_name.to_lower():
			has_item = true
	
	if not has_item:
		return  "You do not have the " + item_name +"."
	
	for npc in current_room.npcs:
		# Question: what is the disadvantage of using the "and" here?
		if npc.quest_item != null and npc.quest_item.item_name.to_lower() == item_name.to_lower():
			npc.has_quest_item = true
			if npc.quest_reward != null:
				# TODO: anyhing with this
				print (npc.quest_reward)
				var reward = npc.quest_reward
				if "is_locked" in reward: # is there an is_locked property in this object
					pass # this is an exit
			player.drop_item (npc.quest_item)
			return "You give the %s to %s." % [item_name, npc.npc_name]
	return "No one here wants the " + item_name +"."
	
func help() -> String:
	return "Commands are one or two words. Available commands are: \n   go [location], \n   take [item],"  \
		+ "\n   drop [item],\n   use [item],\n   talk [character],\n   give [item],\n   inventory,\n   help"
	
func change_room(new_room: Room) -> String:
	current_room = new_room
	room_changed.emit (new_room)
	return new_room.get_full_description()
