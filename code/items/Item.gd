extends Resource
class_name Item

@export var item_name: String = "Item Name"
@export var item_type : Types.ItemTypes = Types.ItemTypes.KEY : set = set_item_type

var use_value = null

# Using setter to cast type to enumeration
func set_item_type (value: int):
	item_type = value as Types.ItemTypes
	
