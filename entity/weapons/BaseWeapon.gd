extends Spatial
class_name BaseWeapon

signal on_weapon_ready_open_fire(_target)

export var sensor_path: NodePath
export var attack_range :int = 0

var attack_delay : float = 0.3
var is_master = false

onready var _sensor : RayCast = get_node(sensor_path)

# misc
var _attack_timmer : Timer
var _sound : AudioStreamPlayer3D

############################################################
# Called when the node enters the scene tree for the first time.
# override methods
func _ready():
	set_process(true)
	
	_attack_timmer = Timer.new()
	_attack_timmer.autostart = false
	_attack_timmer.one_shot = true
	add_child(_attack_timmer)
	
	_sound = AudioStreamPlayer3D.new()
	_sound.bus = "sfx"
	_sound.unit_db = Global.sound_amplified
	_sound.unit_size = Global.sound_amplified
	add_child(_sound)
		
	if is_instance_valid(_sensor):
		_sensor.cast_to =  _sensor.cast_to * attack_range
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_master:
		return
		
	if not _sensor.is_colliding():
		return
		
	var body = _sensor.get_collider()
	if not _is_valid_target(body):
		return
		
	if _attack_timmer.is_stopped():
		emit_signal("on_weapon_ready_open_fire", body)
		_attack_timmer.wait_time = attack_delay
		_attack_timmer.start()
		
func open_fire(_target : BaseEntity):
	_play_firing_animation()
	_spawn_projectile_to(_target.global_transform.origin)

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
		
	if  not _body is BaseEntity:
		return false
		
	return true
	
