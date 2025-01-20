@tool
extends PanelContainer
class_name Room

@export var room_name: String = "Room Name" : set = set_room_name
@export_multiline var room_description: String = "This is the room description" : set = set_room_description

var exits: Dictionary = {}
var npcs: Array = []
var items: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func add_item (new_item: Item):
	items.append(new_item)
	
	
func remove_item(item: Item):
	items.erase(item)
	
	
func add_npc(character: NPC):
	npcs.append (character)


func get_full_description() -> String:
	var full_description = []
	full_description.append(get_room_description())
	if npcs.size() > 0:
		full_description.append(get_npc_description())	
	if items.size() > 0:
		full_description.append(get_item_description())
	full_description.append(get_exit_description())	
	
	var full_description_string = "\n".join(full_description)
	return full_description_string
	
func get_room_description() -> String:
	return 	"You are now in " + room_name + ". It is " + room_description
		

func get_item_description() -> String:
	var item_string = ""
	if items.size() == 0:
		return ""
	for item in items:
		item_string += item.item_name + " "
	return "You see " + item_string


func get_exit_description() -> String:
	var exit_string = " ".join(exits.keys())
	return	"You can go " + exit_string
	
func get_npc_description() -> String:
	var npc_string = ""
	if npcs.size() == 0:
		return ""
	for character in npcs:
		npc_string += character.npc_name + " "
	return "You see " + npc_string
	
	
func connect_exit_unlocked(direction: String, other_room, return_exit_name="") -> Exit:
	return _connect_exit(direction, other_room, false, return_exit_name)

	
func connect_exit_locked(direction: String, other_room, return_exit_name="") -> Exit:
	return _connect_exit(direction, other_room, true, return_exit_name)
	

func _connect_exit(direction: String, other_room, is_locked: bool = false, return_exit_name="") -> Exit:
	if other_room == null:
		printerr("Attempting to connect an exit to a null room ")
		return
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = other_room
	exit.is_locked = is_locked
	exits[direction] = exit
	
	if return_exit_name != "":
		other_room.exits[return_exit_name] = exit
	else:
		other_room.exits[opposite_direction(direction)] = exit
	
	return exit
			
# Helper function to make exits go both ways.
func opposite_direction(direction: String)->String:
	match direction:
		"west":
			return "east"
		"east":
			return "west"
		"north":
			return "south"
		"south":
			return "north"
		"inside":
			return "outside"
		"outside":
			return "inside"
		"path":
			return "path"
		_: return ""


func set_room_name(new_name : String):
	$MarginContainer/Rows/RoomName.text = new_name
	room_name = new_name
	
func set_room_description(new_description : String):
	$MarginContainer/Rows/RoomDescription.text = new_description
	room_description = new_description
	
