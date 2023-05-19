extends Spatial
class_name BaseSensor

signal on_spotted(_node)

# identity owner
var player:PlayerData

export var scanning_speed:float = 0.07
export var spotting_range : int = 1
export var ground_sensor_altitude = 0.2
export var air_sensor_altitude = 10.0

onready var _detected_sounds = [
	preload("res://entity/sensor/sensor_sound/detected_1.wav"),
	preload("res://entity/sensor/sensor_sound/detected_2.wav"),
	preload("res://entity/sensor/sensor_sound/detected_3.wav"),
	preload("res://entity/sensor/sensor_sound/detected_4.wav")
]

var _air_sensor: RayCast
var _ground_sensor: RayCast
var _current_detected : BaseEntity
var _sound : AudioStreamPlayer3D

func _ready():
	_air_sensor = RayCast.new()
	add_child(_air_sensor)
	_air_sensor.enabled = false
	_air_sensor.cast_to = Vector3(0,0,1) * spotting_range
	
	_ground_sensor = RayCast.new()
	add_child(_ground_sensor)
	_ground_sensor.enabled = true
	_ground_sensor.cast_to = Vector3(0,0,1) * spotting_range
	
	_sound = AudioStreamPlayer3D.new()
	_sound.bus = "sfx"
	_sound.unit_db = Global.sound_amplified
	_sound.unit_size = Global.sound_amplified
	add_child(_sound)
	
	set_process(true)
	
func add_exception(_node : BaseEntity):
	_air_sensor.add_exception(_node)
	_ground_sensor.add_exception(_node)
	
func _process(delta):
	rotate_y(rad2deg(scanning_speed) * delta)
	
	_air_sensor.global_transform.origin.y = air_sensor_altitude
	_ground_sensor.global_transform.origin.y = ground_sensor_altitude
	
	#validate_detection(_air_sensor)
	validate_detection(_ground_sensor)
	
	
func validate_detection(raycast : RayCast):
	if not raycast.is_colliding():
		return
		
	var body = raycast.get_collider()
	if not _is_type_entity(body):
		return
		
	if not _is_valid_target(body):
		if  _current_detected == body:
			_current_detected = null
		return
		
	if not _is_close_to(body):
		return
		
	if _current_detected != body:
		_sound.stream = _detected_sounds[rand_range(0,_detected_sounds.size() - 1)]
		_sound.play()
		
	_current_detected = body
	
	emit_signal("on_spotted", body)
	
func _is_type_entity(_body) -> bool:
	if not is_instance_valid(_body):
		return false
			
	if _body is StaticBody:
		return false
		
	if  not _body is BaseEntity:
		return false
		
	return true
	
func _is_valid_target(_body) -> bool:
	if _body.is_dead():
		return false
		
	if player.player_team == _body.team():
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



