extends BaseEntity
class_name BaseTurret

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

# movement
export var elevation_speed_deg: float = 45
export var rotation_speed_deg: float = 90
# bullets
export var muzzle_velocity: float = 50
# constraints
export var min_elevation: float = -15
export var max_elevation: float = 60


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
var ttc: float
var current_aim = Vector3.ZERO

# states
var active: bool = true


############################################################
# multiplayer func
func _network_timmer_timeout():
	._network_timmer_timeout()
	
	if is_dead:
		return
		
	if _is_master():
		rset_unreliable("_puppet_rotation", body.rotation.y)
		rset_unreliable("_puppet_elevation", head.rotation_degrees.x)
		
puppet var _puppet_rotation: float setget _set_puppet_rotation
func _set_puppet_rotation(_val : float):
	_puppet_rotation = _val
	
puppet var _puppet_elevation: float setget _set_puppet_elevation
func _set_puppet_elevation(_val: float):
	_puppet_elevation = _val
	
remotesync func _open_fire(_target : NodePath):
	if not is_instance_valid(_weapon):
		return
		
	var _to = get_node_or_null(_target)
	if not is_instance_valid(_to):
		return
		
	_weapon.open_fire(_to)
	
remotesync func _dead():
	._dead()
	
	if is_instance_valid(_sensor):
		_sensor.set_process(false)
		
	if is_instance_valid(_weapon):
		_weapon.set_process(false)
		
	
################################
# OVERRIDE FUNCTIONS
################################
func _ready() -> void:
	tag = "turret"
	active = false
	
func spawn_weapon(_pos : Vector3):
	if weapon_scene:
		var _weapon_asset = weapon_scene.instance()
		head.add_child(_weapon_asset)
		_weapon = _weapon_asset
		_weapon.translation = _pos
		
	if not _is_master():
		return
		
	if is_instance_valid(_weapon):
		_weapon.connect("on_weapon_ready_open_fire", self,"_on_weapon_ready_open_fire")
		_weapon.is_master = true
	
func spawn_sensor(_pos : Vector3):
	if sensor_scene:
		var _sensor_asset = sensor_scene.instance()
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
	
############################################################
# function
func master_moving(delta):
	# if not active do nothing
	if not active:
		return
		
	if is_dead:
		return
		
	# move
	_rotate(delta)
	_elevate(delta)
	
func puppet_moving(_delta):
	if is_dead:
		return
		
	body.rotation.y = lerp_angle(body.rotation.y, _puppet_rotation, _delta * 5)
	head.rotation_degrees.x = lerp_angle(head.rotation_degrees.x, _puppet_elevation, _delta * 5)
	
################################
# signal handling
func _on_weapon_ready_open_fire(_target : BaseEntity):
	if not _is_master():
		return
	
	if is_dead:
		return
	
	rpc_unreliable("_open_fire", _target.get_path())
	
func _on_sensor_spotted(_target : BaseEntity):
	if not _is_master():
		return
		
	if is_dead:
		return
		
	current_aim = _target.global_transform.origin
	active = true
	
################################
# MAIN FUNCTIONS
################################
func _rotate(delta: float) -> void:
	var y_target = _get_local_y()
	var final_y = sign(y_target) * min(rotation_speed * delta, abs(y_target))
	body.rotate_y(final_y)
	
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
	var local_target = head.to_local(current_aim)
	var y_angle = Vector3.FORWARD.angle_to(local_target * Vector3(1, 0, 1))
	return y_angle * sign(local_target.x)
	
func _get_global_x() -> float:
	var local_target = current_aim - head.global_transform.origin
	return (local_target * Vector3(1, 0, 1)).angle_to(local_target) * -sign(local_target.y)
	

