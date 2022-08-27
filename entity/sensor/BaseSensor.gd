extends Spatial
class_name BaseSensor

signal on_spotted(_node)

export var spotting_rotation_speed = 0.07
export var raycast_path: Array

var _raycasts: Array
var spotting_range : int setget _set_spotting_range

func _set_spotting_range(_val : int):
	spotting_range = _val
	for raycast in _raycasts:
		raycast.cast_to = raycast.cast_to * spotting_range
	
func add_exception(_node : BaseEntity):
	for raycast in _raycasts:
		raycast.add_exception(_node)
	
func _ready():
	for raycast in raycast_path:
		_raycasts.append(get_node(raycast))
		
	set_process(true)
	
func _process(delta):
	var rot_speed = rad2deg(spotting_rotation_speed)
	rotate_y(rot_speed * delta)
	
	for raycast in _raycasts:
		if raycast.is_colliding():
			var body = raycast.get_collider()
			if _is_valid_target(body):
				emit_signal("on_spotted", body)
				return
			
func _is_valid_target(_body) -> bool:
	if not is_instance_valid(_body):
		return false
		
	if _body is GameplayCamera:
		return false
		
	if _body is StaticBody:
		return false
		
	if not _body is BaseEntity:
		return false
		
	return true
	
