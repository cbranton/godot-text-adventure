extends Resource
class_name Exit

var room_1 = null;
var room_2 = null;
var is_locked := false


func get_destination_room (source_room):
	if source_room == room_1:
		return room_2
	elif source_room == room_2:
		return room_1
	else:
		printerr ("This exit doesn't go there.")
