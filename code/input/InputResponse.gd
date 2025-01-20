extends VBoxContainer

class_name InputResponse

# @onready var input_label = $Rows/InputHistory
# @onready var response_label = $Rows/Response

const prompt: String = " > "


func set_text(input:String, response: String):
	if input == "":
		$Rows/InputHistory.queue_free()
	else:
		$Rows/InputHistory.text = prompt + input
		
	$Rows/Response.text = response
