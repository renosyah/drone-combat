extends Spatial
class_name BaseWeapon

signal on_weapon_ready_open_fire(_target)

# identity owner
var player:PlayerData

export var projectile :Resource
export var sensor_path: NodePath
export var attack_range :int = 0
export var ammo_cost :int = 1
export var dispersion :float = 0.2 
export var attack_delay : float = 0.3

var is_master = false
var _bullets_pool = []

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
	
	setup_bullets_pool()
	
	if is_instance_valid(_sensor):
		_sensor.cast_to = _sensor.cast_to * attack_range
		
func _on_attack_timmer_timeout():
	pass
	
func add_exception(_node : BaseEntity):
	_sensor.add_exception(_node)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_master:
		_master_weapon_handling(delta)
	else:
		_puppet_weapon_handling(delta)
	
func _master_weapon_handling(delta):
	if not _sensor.is_colliding():
		return
		
	var body = _sensor.get_collider()
	if not _is_valid_target(body):
		return
		
	if _attack_timmer.is_stopped():
		emit_signal("on_weapon_ready_open_fire", body)
		_on_attack_timmer_timeout()
		_attack_timmer.wait_time = attack_delay
		_attack_timmer.start()
	
func _puppet_weapon_handling(delta):
	if _attack_timmer.is_stopped():
		_on_attack_timmer_timeout()
	
func open_fire(_target : BaseEntity):
	_play_firing_animation()
	_spawn_projectile_to(_target)
	
func create_bullet_instance() -> BaseProjectile:
	var bullet = projectile.instance()
	bullet.player = player
	bullet.is_master = is_master
	bullet.show_projectile = false
	add_child(bullet)
	bullet.spread = dispersion
	bullet.translation = Vector3.ZERO
	return bullet
	
func setup_bullets_pool():
	for i in range(25):
		_bullets_pool.append(create_bullet_instance())
	
func get_bullet_from_pool() -> BaseProjectile:
	for i in _bullets_pool:
		if not i.show_projectile:
			return i
			
	return create_bullet_instance()
	
func _play_firing_animation():
	if not is_master and _attack_timmer.is_stopped():
		_attack_timmer.wait_time = attack_delay
		_attack_timmer.start()
	# override where project
	# want to animate each firing
	
func _spawn_projectile_to(_target : BaseEntity):
	# override where project
	# want to spawn in each weapon
	pass
	
func _is_valid_target(_body) -> bool:
	if not is_instance_valid(_body):
		return false
		
	if _body is StaticBody:
		return false
		
	if  not _body is BaseEntity:
		return false
		
	if player.player_team == _body.team():
		return false
		
	return true
	
