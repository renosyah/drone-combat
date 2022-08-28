extends Spatial
class_name BaseWeapon

signal on_weapon_sensor_detect(_entity)

export var sensor_path: NodePath
export var attack_range :int = 0

var attack_delay : float = 0.3
var is_master = false

onready var _sensor : RayCast = get_node(sensor_path)

# misc
var _attack_timmer : Timer = null

############################################################
# Called when the node enters the scene tree for the first time.
# override methods
func _ready():
	set_process(true)
	
	if not _attack_timmer:
		_attack_timmer = Timer.new()
		_attack_timmer.autostart = false
		_attack_timmer.one_shot = true
		add_child(_attack_timmer)
		
	if _sensor:
		_sensor.cast_to =  _sensor.cast_to * attack_range
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _sensor.is_colliding():
		return
		
	var body = _sensor.get_collider()
	if not _is_valid_target(body):
		return
		
	emit_signal("on_weapon_sensor_detect", body)
	
	
func open_fire(_target : BaseEntity):
	if _attack_timmer.is_stopped():
		_play_firing_animation()
		_spawn_projectile_to(_target.global_transform.origin)
		_attack_timmer.wait_time = attack_delay
		_attack_timmer.start()
		
func _play_firing_animation():
	# override where project
	# want to animate each firing
	pass
	
func _spawn_projectile_to(direction : Vector3):
	# override where project
	# want to spawn in each weapon
	pass
	
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
	
