extends BaseEntity
class_name BaseHull

signal on_hull_click(_hull)

# variables
const NONE = 1
const IDDLE = 1
const MOVING = 2

# will be waypoint vector 3
var waypoint = null
var direction = Vector2.ZERO

export var waypoint_mode = false

export var speed : float = 2.0
export var turning_speed : float = 4.0

export var turret_hp :int = 100
export var turret_max_hp :int = 100

export var spotting_range :int = 18
export var scanning_speed:float = 0.07

export var turret_scene: Resource
export var weapon_scene: Resource
export var sensor_scene: Resource

export var color : Color

var _turret : BaseTurret

var _offset_distance = 0.5
var _velocity = Vector3.ZERO

var _moving_state : int = IDDLE

# input
var _click_translation = Vector3.ZERO
var _input_detector : Node

# misc
var _tween_movement : Tween = null


############################################################
# multiplayer func
func set_network_master(id: int, recursive: bool = true):
	if _turret:
		_turret.set_network_master(id, recursive)
		
	.set_network_master(id, recursive)
	
func _network_timmer_timeout():
	._network_timmer_timeout()
	
	if is_dead:
		return
		
	if _is_master():
		rset_unreliable("_puppet_translation", translation)
		rset_unreliable("_puppet_rotation", rotation)
		rset_unreliable("_puppet_moving_state", _moving_state)
	
puppet var _puppet_translation :Vector3 setget _set_puppet_translation
func _set_puppet_translation(_val :Vector3):
	_puppet_translation = _val
	
	if is_dead:
		return
	
	if _is_master():
		return
		
	_tween_movement.interpolate_property(self,"translation", translation, _puppet_translation, 0.5)
	_tween_movement.start()
	
puppet var _puppet_rotation: Vector3 setget _set_puppet_rotation
func _set_puppet_rotation(_val:Vector3):
	_puppet_rotation = _val
	
puppetsync var _puppet_moving_state : int setget _set_puppet_moving_state
func _set_puppet_moving_state(_val : int):
	_puppet_moving_state = _val
	
	if _is_master():
		return
		
	_moving_state = _puppet_moving_state
	
############################################################
# Called when the node enters the scene tree for the first time.
# override methods
func _ready():
	set_process(true)
	tag = "hull"
	
	connect("input_event", self, "_on_input_event")
	
	var _detector = preload("res://assets/other/input_detection/input_detection.tscn").instance()
	add_child(_detector)
	_input_detector = _detector
	_input_detector.connect("any_gesture", self, "_on_inputDetection_any_gesture")
	
	if not _tween_movement:
		_tween_movement = Tween.new()
		add_child(_tween_movement)
		
	if not _is_master():
		return
		
	if not _network_timmer:
		_network_timmer = Timer.new()
		_network_timmer.wait_time = _latency_delay
		_network_timmer.connect("timeout", self , "_network_timmer_timeout")
		_network_timmer.autostart = true
		add_child(_network_timmer)
		
	emit_signal("on_ready", self)
	
	
func spawn_turret(_pos : Vector3 = Vector3.ZERO):
	if turret_scene:
		var _turret_asset = turret_scene.instance()
		_turret_asset.hp = turret_hp
		_turret_asset.max_hp = turret_max_hp
		_turret_asset.weapon_scene = weapon_scene
		_turret_asset.sensor_scene = sensor_scene
		_turret_asset.color = color
		_turret_asset.spotting_range = spotting_range
		_turret_asset.scanning_speed = scanning_speed
		add_child(_turret_asset)
		_turret = _turret_asset
		_turret.translation = _pos
		_turret.rotation.y = 180
		
	if is_instance_valid(_turret):
		_turret.connect("on_take_damage", self,"_on_turret_take_damage" )
		_turret.connect("on_dead", self,"_on_turret_on_dead" )
	
func _on_turret_take_damage(_entity, _damage):
	emit_signal("on_take_damage", _entity, _damage)
	
func _on_turret_on_dead(_entity):
	emit_signal("on_dead",_entity)
	
############################################################
# function
func master_moving(delta):
	if is_dead:
		return
		
	if waypoint_mode:
		move_to_waypoint(delta)
	else:
		move_by_input(delta)
	
func move_by_input(delta):
	if  direction != Vector2.ZERO:
		direction.normalized()
		_transform_turning(Vector3(direction.x, 0.0 , direction.y) + translation, delta)
		_moving_state = MOVING
		_velocity = Vector3(direction.x, 0.0 , direction.y) * speed
	else:
		_moving_state = IDDLE
		_velocity = Vector3.ZERO
		
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
func move_to_waypoint(delta):
	if not waypoint:
		return 
		
	if not waypoint is Vector3:
		return
		
	var direction_to_waypoint = global_transform.origin.direction_to(waypoint)
	var distance_to_target = global_transform.origin.distance_to(waypoint)
	
	if distance_to_target > _offset_distance:
		_transform_turning(waypoint, delta)
		_moving_state = MOVING
		_velocity = direction_to_waypoint * speed
		
	else:
		_moving_state = IDDLE
		_velocity = Vector3.ZERO
		waypoint = null
		
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
	
func moving(_delta):
	if is_dead:
		return
	
func puppet_moving(_delta):
	if is_dead:
		return
		
	rotation.x = lerp_angle(rotation.x, _puppet_rotation.x, _delta * 5)
	rotation.y = lerp_angle(rotation.y, _puppet_rotation.y, _delta * 5)
	rotation.z = lerp_angle(rotation.z, _puppet_rotation.z, _delta * 5)
	
func is_dead() -> bool:
	if not _turret:
		return is_dead
		
	return is_dead && _turret.is_dead()
	
############################################################
# input
func _on_input_event(camera, event, position, normal, shape_idx):
	_click_translation = position
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		emit_signal("on_hull_click", self)
		
	# if touch screen
	_input_detector.check_input(event)
	
func _on_inputDetection_any_gesture(sig ,event):
	if event is InputEventSingleScreenTap:
		emit_signal("on_hull_click", self)
		
############################################################
# utils
func _transform_turning(direction, delta):
	direction.y = translation.y
	var new_transform = transform.looking_at(direction, Vector3.UP)
	transform = transform.interpolate_with(new_transform, turning_speed * delta)

