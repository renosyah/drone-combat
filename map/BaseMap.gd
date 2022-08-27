extends StaticBody
class_name BaseMap

signal on_map_click(_pos)

var _click_translation = Vector3.ZERO
var _input_detector : Node

func _ready():
	connect("input_event", self, "_on_input_event")
	
	var _detector = preload("res://assets/other/input_detection/input_detection.tscn").instance()
	add_child(_detector)
	_input_detector = _detector
	_input_detector.connect("any_gesture", self, "_on_inputDetection_any_gesture")
	
func _on_input_event(camera, event, position, normal, shape_idx):
	_click_translation = position
	_click_translation.y = 0
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		emit_signal("on_map_click", _click_translation)
		
	# if touch screen
	_input_detector.check_input(event)
	
func _on_inputDetection_any_gesture(sig ,event):
	if event is InputEventSingleScreenTap:
		emit_signal("on_map_click", _click_translation)
	
