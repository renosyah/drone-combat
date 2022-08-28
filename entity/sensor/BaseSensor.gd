extends Spatial
class_name BaseSensor

signal on_spotted(_node)

export var spotting_rotation_speed = 0.07
export var raycast_path: Array
export var spotting_range : int = 1

var _raycasts: Array = []
var _current_detected : BaseEntity

func add_exception(_node : BaseEntity):
	for raycast in _raycasts:
		raycast.add_exception(_node)
	
func _ready():
	for raycast in raycast_path:
		var ray = get_node(raycast)
		ray.cast_to = ray.cast_to * spotting_range
		_raycasts.append(ray)
		
	set_process(true)
	
func _process(delta):
	var rot_speed = rad2deg(spotting_rotation_speed)
	rotate_y(rot_speed * delta)
	
	for raycast in _raycasts:
		validate_detection(raycast)
	
	
func validate_detection(raycast : RayCast):
	if not raycast.is_colliding():
		return
		
	var body = raycast.get_collider()
	if not _is_type_entity(body):
		return
		
	if not _is_close_to(body):
		return
		
	_current_detected = body
		
	if not _is_valid_target(body):
		return
		
	emit_signal("on_spotted", body)
	
func _is_type_entity(_body) -> bool:
	if not is_instance_valid(_body):
		return false
		
	if _body is GameplayCamera:
		return false
		
	if _body is StaticBody:
		return false
		
	if not _body is BaseEntity:
		return false
		
	return true
	
func _is_valid_target(_body) -> bool:
	if _body.is_dead():
		return false
		
	return true
	
func _is_close_to(_body) -> bool:
	if not is_instance_valid(_current_detected):
		_current_detected = _body
		
	if _current_detected == _body:
		return true
		
	var new_aim_dis = _body.global_transform.origin.distance_to(global_transform.origin)
	var current_aim_dis = _current_detected.global_transform.origin.distance_to(global_transform.origin)
	
	if new_aim_dis > current_aim_dis:
		return false
	
	return true



