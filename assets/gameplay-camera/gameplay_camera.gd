extends KinematicBody
class_name GameplayCamera

signal on_camera_moving(_translation, _zoom)

onready var _camera = $Camera

export(bool) var is_enable = true
export(float) var speed = 16.0

var min_zoom : float = 15.0
var max_zoom : float = 40.0
var zoom_sensitivity : float = 10.0
var zoom_speed : float = 0.05

var events : Dictionary = {}
var last_drag_distance : float = 0.0
var drag_speed : float = 0.0025

func camera_keep_aspect(_aspect):
	_camera.keep_aspect = _aspect
	
func _input(event):
	if not is_enable:
		return
		
	if event.is_action("scroll_down"):
		if(_camera.translation.z + zoom_speed + 1.0 <= max_zoom):
			_camera.translation.z += zoom_speed + 1.0
			
	elif event.is_action("scroll_up"):
		if(_camera.translation.z - zoom_speed + 1.0 >= min_zoom):
			_camera.translation.z -= zoom_speed + 1.0
			
			
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
			
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			var velocity = Vector3.ZERO
			velocity.x = -event.relative.x
			velocity.z = -event.relative.y
			
			move_and_slide(velocity * (_camera.translation.z * drag_speed) * speed)
			get_tree().set_input_as_handled()
			
		elif events.size() == 2:
			if not events.has(0) or not events.has(1):
				return
				
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
				new_zoom = clamp(_camera.translation.z * new_zoom, min_zoom, max_zoom)
				_camera.translation.z = new_zoom
				last_drag_distance = drag_distance
			get_tree().set_input_as_handled()
				
	var _opacity = (((_camera.translation.z - min_zoom) * 100) / (max_zoom - min_zoom)) / 100.0
	emit_signal("on_camera_moving", translation, _opacity)
