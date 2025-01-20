extends PanelContainer

@onready var room_name = $MarginContainer/Rows/RoomArea/RoomNameLabel
@onready var room_description = $MarginContainer/Rows/RoomArea/RoomDescriptionLabel
@onready var exit_label = $MarginContainer/Rows/ListArea/ExitLabel


func on_room_changed(new_room:Room):
	
	room_name.text = new_room.room_name
	room_description.text = new_room.room_description
	
	exit_label.text = new_room.get_exit_description()
