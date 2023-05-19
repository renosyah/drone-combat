extends BaseEntity
class_name BaseTurret

signal on_resupply(_turret, _ammo_added)
signal on_turret_ammo_update(_turret, _ammo_left, _max_ammo)

################################
# EXPORT PARAMS
################################
# parts
export var body_path: NodePath
export var head_path: NodePath
export var weapon_scene: Resource
export var sensor_scene: Resource
export var color : Color
export var spotting_range :int = 18
export var scanning_speed:float = 0.07
export var ammo :int = 5
export var max_ammo :int = 5

# movement
export var elevation_speed_deg: float = 45
export var rotation_speed_deg: float = 90

# constraints
export var min_elevation: float = -8
export var max_elevation: float = 15

################################
# PARAMS
################################
# parts
onready var body: Spatial = get_node(body_path)
onready var head: Spatial = get_node(head_path)
var _sensor: BaseSensor
var _weapon : BaseWeapon

# movement
onready var elevation_speed: float = deg2rad(elevation_speed_deg)
onready var rotation_speed: float = deg2rad(rotation_speed_deg)

# target calculation
var target :BaseEntity

# states
var active: bool = true

# misc
var _reset_turret_timer : Timer
var _tween_rotation : TweenRotation
var _invisible_body : Spatial

############################################################
# multiplayer func
func _network_timmer_timeout():
	._network_timmer_timeout()
	
	if is_dead:
		return
		
	if _is_master():
		rset_unreliable("_puppet_rotation", _invisible_body.rotation.y)
		rset_unreliable("_puppet_elevation", head.rotation_degrees.x)
		
puppet var _puppet_rotation: float setget _set_puppet_rotation
func _set_puppet_rotation(_val : float):
	_puppet_rotation = _val
	
puppet var _puppet_elevation: float setget _set_puppet_elevation
func _set_puppet_elevation(_val: float):
	_puppet_elevation = _val
	
remotesync func _resupply(_current_ammo, _ammo_added :int):
	if not _is_master():
		ammo = _current_ammo
		
	emit_signal("on_resupply", self, _ammo_added)
	
remotesync func _open_fire(_ammo_left :int, _target : NodePath):
	if not _is_master():
		ammo = _ammo_left
		
	if not is_instance_valid(_weapon):
		return
		
	var _to = get_node_or_null(_target)
	if not is_instance_valid(_to):
		return
		
	_weapon.open_fire(_to)
	emit_signal("on_turret_ammo_update", self, ammo, max_ammo)
	
remotesync func _dead(_kill_by :Dictionary):
	._dead(_kill_by)
	
	if is_instance_valid(_sensor):
		_sensor.set_process(false)
		
	if is_instance_valid(_weapon):
		_weapon.set_process(false)
		
remotesync func _reset():
	._reset()
	
	if is_instance_valid(_sensor):
		_sensor.set_process(true)
		
	if is_instance_valid(_weapon):
		_weapon.set_process(true)
		
	
################################
# OVERRIDE FUNCTIONS
################################
func _ready() -> void:
	tag = "turret"
	active = false
	
	if not _is_master():
		return
		
	var _timer = Timer.new()
	_timer.wait_time = 5.0
	_timer.autostart = true
	_timer.connect("timeout", self ,"_on_reset_turret_timer_timeout")
	add_child(_timer)
	_reset_turret_timer = _timer
	
	_invisible_body = Spatial.new()
	get_parent().add_child(_invisible_body)
	_invisible_body.rotation_degrees.y = 180.0
	
	var _tween_rot = preload("res://assets/other/tween_rotation/tween_rotation.tscn").instance()
	_tween_rot.target = _invisible_body
	add_child(_tween_rot)
	_tween_rotation = _tween_rot
	
func _on_reset_turret_timer_timeout():
	if not _is_master():
		return
	
	if not active and not is_dead:
		_tween_rotation.default_rotation_degree = 180.0
		_tween_rotation.start_reset_rotation()
	
	target = null
	active = false
	
func spawn_weapon(_pos : Vector3):
	if weapon_scene:
		var _weapon_asset = weapon_scene.instance()
		_weapon_asset.player = player
		_weapon_asset.is_master = _is_master()
		head.add_child(_weapon_asset)
		_weapon = _weapon_asset
		_weapon.translation = _pos
		_weapon.add_exception(self)
		_weapon.add_exception(get_parent())
		
	if not _is_master():
		return
		
	if is_instance_valid(_weapon):
		_weapon.connect("on_weapon_ready_open_fire", self,"_on_weapon_ready_open_fire")
	
func spawn_sensor(_pos : Vector3):
	if sensor_scene:
		var _sensor_asset = sensor_scene.instance()
		_sensor_asset.player = player
		_sensor_asset.spotting_range = spotting_range
		_sensor_asset.scanning_speed = scanning_speed
		add_child(_sensor_asset)
		_sensor = _sensor_asset
		_sensor.translation = _pos
		_sensor.add_exception(self)
		_sensor.add_exception(get_parent())
		
	if not _is_master():
		return
		
	if is_instance_valid(_sensor):
		_sensor.connect("on_spotted", self, "_on_sensor_spotted")
		
func resupply(_ammo_added :int):
	if not _is_master():
		return
		
	if ammo + _ammo_added > max_ammo:
		ammo = max_ammo
	else:
		ammo += _ammo_added
		
	rpc("_resupply", ammo, _ammo_added)
	
############################################################
# function
func master_moving(delta):
	.master_moving(delta)
	
	if not _invisible_body or not body:
		return
		
	body.rotation.y = lerp_angle(body.rotation.y, _invisible_body.rotation.y, delta * 5)
	
	# if not active do nothing
	if not active:
		return
		
	if is_dead:
		return
		
	if not is_instance_valid(target):
		return
		
	if target.is_dead():
		target = null
		active = false
		return
		
	# move
	_rotate(delta)
	_elevate(delta)
	
func puppet_moving(_delta):
	.puppet_moving(_delta)
	
	if is_dead:
		return
		
	body.rotation.y = lerp_angle(body.rotation.y, _puppet_rotation, _delta * 5)
	head.rotation_degrees.x = _puppet_elevation
	
################################
# signal handling
func _on_weapon_ready_open_fire(_target : BaseEntity):
	if not _is_master():
		return
		
	if is_dead:
		return
		
	if _target.is_dead():
		return
		
	if ammo < 1:
		return
		
	if not is_instance_valid(_weapon):
		return
		
	ammo -= _weapon.ammo_cost
	if ammo < 0:
		ammo = 0
		
	rpc_unreliable("_open_fire", ammo, _target.get_path())
	
func _on_sensor_spotted(_target : BaseEntity):
	if not _is_master():
		return
		
	if is_dead:
		return
		
	_tween_rotation.stop_reset_rotation()
	
	target = _target
	active = true
	
################################
# MAIN FUNCTIONS
################################
func _rotate(delta: float) -> void:
	var y_target = _get_local_y()
	var final_y = sign(y_target) * min(rotation_speed * delta, abs(y_target))
	_invisible_body.rotate_y(final_y)
	
func _elevate(delta: float) -> void:
	var x_target = _get_global_x()
	var x_diff = x_target - head.global_transform.basis.get_euler().x
	var final_x = sign(x_diff) * min(elevation_speed * delta, abs(x_diff))
	head.rotate_x(final_x)
	head.rotation_degrees.x = clamp(
		head.rotation_degrees.x,
		min_elevation, max_elevation
	)
	
################################
# HELPER FUNCTIONS
################################
func _get_local_y() -> float:
	var current_aim = target.global_transform.origin
	var local_target = head.to_local(current_aim)
	var y_angle = Vector3.FORWARD.angle_to(local_target * Vector3(1, 0, 1))
	return y_angle * sign(local_target.x)
	
func _get_global_x() -> float:
	var current_aim = target.global_transform.origin
	var local_target = current_aim - head.global_transform.origin
	return (local_target * Vector3(1, 0, 1)).angle_to(local_target) * -sign(local_target.y)
	

