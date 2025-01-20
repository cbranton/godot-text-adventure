extends Resource
class_name NPC

@export var npc_name: String = "Character"
@export_multiline var initial_dialog: String = "Hey there!"
@export_multiline var post_quest_dialog: String = "Bye!"

@export var quest_item: Item = null

var has_quest_item := false
var quest_reward = null
