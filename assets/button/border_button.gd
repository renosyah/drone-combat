extends Button
class_name BorderButton

export var button_color :Color = Color.gray setget _set_button_color
export var button_label :String = "" setget _set_button_label

func _set_button_color(val :Color):
	button_color = val
	$ColorRect.color = button_color
	
func _set_button_label(val :String):
	button_label = val
	$Label.text = button_label
