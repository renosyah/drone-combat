extends BaseEntity
class_name BaseHull

signal on_hull_click(_hull)
signal on_respawn_ready(_hull)

# variables
const NONE = 1
const IDDLE = 1
const MOVING = 2

# will be waypoint vector 3
var waypoint = null
var direction = Vector2.ZERO

export var waypoint_mode = false

var drone_data: DroneData

export var speed : float = 2.0
export var turning_speed : float = 4.0

export var turret_hp :int = 100
export var turret_max_hp :int = 100

export var turret_ammo :int = 5
export var turret_max_ammo :int = 5

export var turret_rotation_speed = 90

export var spotting_range :int = 18
export var scanning_speed:float = 0.07

export var turret_scene: Resource
export var weapon_scene: Resource
export var sensor_scene: Resource

export var color : Color

var _turret : BaseTurret

var _offset_distance = 0.5
var _altitude = 0.0
var _gravity = -12.0
var _velocity = Vector3.ZERO

var _moving_state :int = IDDLE

# input
var _click_translation = Vector3.ZERO
var _input_detector :Node

# misc
var _tween_movement :Tween
var _explosion :Explosion
var _hp_bar :HpBar3D
var _sound : AudioStreamPlayer3D
var _respawn_delay :Timer

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
		rset_unreliable("_puppet_direction", direction)
		
puppet var _puppet_direction :Vector2 setget _set_puppet_direction
func _set_puppet_direction(_val :Vector2):
	_puppet_direction = _val
	if _is_master():
		return
		
	direction = _puppet_direction
	
puppet var _puppet_translation :Vector3 setget _set_puppet_translation
func _set_puppet_translation(_val :Vector3):
	_puppet_translation = _val
	
	if is_dead:
		return
	
	if _is_master():
		return
		
	_tween_movement.interpolate_property(self,"translation", translation, _puppet_translation, Network.LATENCY_TWEEN)
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
	
remotesync func _heal(_hp_left, _hp_added : int):
	._heal(_hp_left, _hp_added)
	
	_hp_bar.update_bar(hp, max_hp)
	
remotesync func _take_damage(_hp_left, _damage : int, _hit_by :Dictionary):
	._take_damage(_hp_left, _damage, _hit_by)
	
	_hp_bar.update_bar(hp, max_hp)
	
remotesync func _reset():
	._reset()
	
	_hp_bar.update_bar(hp, max_hp)
	
	emit_signal("on_respawn", self)
	
remotesync func _dead(_kill_by :Dictionary):
	._dead(_kill_by)
	
	_hp_bar.update_bar(0, max_hp)
	_explosion.explode()
	
	if is_instance_valid(_turret):
		_turret.dead(hit_by_player)
		
############################################################
# Called when the node enters the scene tree for the first time.
# override methods
func _ready():
	set_process(true)

	tag = "hull"
	
	hp = drone_data.hp
	max_hp = drone_data.max_hp
	
	speed = drone_data.speed
	turning_speed = drone_data.turning_speed
	
	turret_hp = drone_data.turret_hp
	turret_max_hp = drone_data.turret_max_hp
	
	turret_ammo = drone_data.turret_ammo
	turret_max_ammo = drone_data.turret_max_ammo
	
	spotting_range = drone_data.spotting_range
	scanning_speed = drone_data.scanning_speed
	
	turret_rotation_speed = drone_data.turret_rotation_speed
	
	turret_scene = load(drone_data.turret_module.scene)
	weapon_scene = load(drone_data.weapon_module.scene)
	sensor_scene = load(drone_data.sensor_module.scene)
	
	color = drone_data.color
	
	var _bar = preload("res://assets/ui/bar-3d/hp_bar_3d.tscn").instance()
	add_child(_bar)
	_hp_bar = _bar
	_hp_bar.update_bar(hp, max_hp)
	_hp_bar.update_ammo_bar(turret_ammo, turret_max_ammo)
	_hp_bar.set_player_name(player.player_name)
	_hp_bar.show_label(true)
	_hp_bar.translation.y = 3.8
	_hp_bar.visible = false
	
	connect("input_event", self, "_on_input_event")
	
	var _detector = preload("res://assets/other/input_detection/input_detection.tscn").instance()
	add_child(_detector)
	_input_detector = _detector
	_input_detector.connect("any_gesture", self, "_on_inputDetection_any_gesture")
	
	_tween_movement = Tween.new()
	add_child(_tween_movement)
	
	_explosion = preload("res://assets/other/explosion/explosion.tscn").instance()
	add_child(_explosion)
	
	_sound = AudioStreamPlayer3D.new()
	_sound.bus = "sfx"
	_sound.unit_db = Global.sound_amplified
	_sound.unit_size = Global.sound_amplified
	add_child(_sound)
	
	_respawn_delay = Timer.new()
	_respawn_delay.wait_time = 25
	_respawn_delay.one_shot = true
	_respawn_delay.autostart = false
	add_child(_respawn_delay)
	_respawn_delay.connect("timeout", self, "_on_respawn_delay_timeout")
	
	
func set_hp_bar(_hp_bar_color :Color, _hp_bar_visible :bool):
	if not is_instance_valid(_hp_bar):
		return
		
	_hp_bar.visible = _hp_bar_visible
	_hp_bar.set_hp_bar_color(_hp_bar_color)
	
func spawn_turret(_pos : Vector3 = Vector3.ZERO):
	if turret_scene:
		var _turret_asset = turret_scene.instance()
		_turret_asset.player = player
		_turret_asset.hp = turret_hp
		_turret_asset.max_hp = turret_max_hp
		_turret_asset.ammo = turret_ammo
		_turret_asset.max_ammo = turret_max_ammo
		_turret_asset.weapon_scene = weapon_scene
		_turret_asset.sensor_scene = sensor_scene
		_turret_asset.color = color
		_turret_asset.spotting_range = spotting_range
		_turret_asset.scanning_speed = scanning_speed
		_turret_asset.rotation_speed_deg = turret_rotation_speed
		add_child(_turret_asset)
		_turret = _turret_asset
		_turret.translation = _pos
		_turret.rotation_degrees.y = 180.0
		
		_turret.connect("on_turret_ammo_update", self, "_on_turret_ammo_update")
		_turret.connect("on_resupply", self, "_on_turret_resupply")
	
func _on_turret_resupply(_t :BaseTurret, _ammo_added :int):
	_hp_bar.update_ammo_bar(_t.ammo, _t.max_ammo)

func _on_turret_ammo_update(_t :BaseTurret, _ammo_left :int, _max_ammo :int):
	_hp_bar.update_ammo_bar(_ammo_left, _max_ammo)
	
func start_respawn_delay(time :float = 25.0):
	_respawn_delay.wait_time = time
	_respawn_delay.start()
	
func _on_respawn_delay_timeout():
	emit_signal("on_respawn_ready", self)
	
func get_turret() -> BaseTurret:
	return _turret
	
############################################################
# function
func master_moving(delta):
	if is_dead:
		return
		
	if int(round(global_transform.origin.y)) > int(_altitude):
		_velocity.y += _gravity * delta
		_velocity = move_and_slide(_velocity, Vector3.UP)
		return
		
	translation.y = _altitude
		
	if waypoint_mode:
		move_to_waypoint(delta)
	else:
		move_by_input(delta)
		
	
func move_by_input(delta):
	if  direction != Vector2.ZERO:
		direction.normalized()
		_moving_state = MOVING
		_transform_turning(Vector3(direction.x, _altitude , direction.y) + translation, delta)
		_velocity = Vector3(direction.x, _altitude , direction.y) * speed
	else:
		_moving_state = IDDLE
		_velocity = Vector3.ZERO
		
	_velocity = move_and_slide(_velocity, Vector3.UP)
		
	
func move_to_waypoint(delta):
	if not waypoint:
		return 
		
	if not waypoint is Vector3:
		return
		
	var _waypoint = Vector3(waypoint.x, _altitude, waypoint.z)
	var direction_to_waypoint = global_transform.origin.direction_to(_waypoint)
	var distance_to_target = global_transform.origin.distance_to(_waypoint)
	direction = Vector2(direction_to_waypoint.x, direction_to_waypoint.z)
	
	if distance_to_target > _offset_distance:
		_moving_state = MOVING
		_transform_turning(_waypoint, delta)
		_velocity = direction_to_waypoint * speed
		
	else:
		_moving_state = IDDLE
		_velocity = Vector3.ZERO
		waypoint = null
		
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
func puppet_moving(_delta):
	if is_dead:
		return
		
	rotation.x = lerp_angle(rotation.x, _puppet_rotation.x, _delta * 5)
	rotation.y = lerp_angle(rotation.y, _puppet_rotation.y, _delta * 5)
	rotation.z = lerp_angle(rotation.z, _puppet_rotation.z, _delta * 5)
	
func resupply(_ammo_added : int):
	if not is_instance_valid(_turret):
		return
	
	if is_dead:
		return
		
	_sound.stream = preload("res://entity/item/sound/item_picked_up.wav")
	_sound.play()
		
	_turret.resupply(_ammo_added)
	
func heal(_hp_added : int):
	.heal(_hp_added)
	
	if is_dead:
		return
		
	_sound.stream = preload("res://entity/item/sound/item_picked_up.wav")
	_sound.play()
	
	if not _is_master():
		return
		
	if is_instance_valid(_turret):
		_turret.reset()
	
func reset():
	.reset()
	
	if not _is_master():
		return
		
	if is_instance_valid(_turret):
		_turret.ammo = _turret.max_ammo
		_turret.reset()
	
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

