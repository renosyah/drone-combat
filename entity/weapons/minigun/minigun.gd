extends BaseWeapon

onready var _projectile_spawn_pos = $projectile_spawn_pos
onready var _projectile_target_pos = $projectile_target_pos
onready var _animation_player = $AnimationPlayer
onready var _firing_sounds = [
	preload("res://entity/weapons/mg/firing_1.wav"),
	preload("res://entity/weapons/mg/firing_2.wav"),
	preload("res://entity/weapons/mg/firing_3.wav")
]

var minigun_firing :bool = false
var minigun_rate_fire :Timer

func _ready():
	minigun_rate_fire = Timer.new()
	minigun_rate_fire.wait_time = 0.08
	minigun_rate_fire.autostart = false
	minigun_rate_fire.one_shot = true
	add_child(minigun_rate_fire)
	
	attack_delay = 1.0
	_attack_timmer.connect("timeout", self, "_on_attack_timmer_timeout")
	
func _on_attack_timmer_timeout():
	minigun_firing = false
	_animation_player.play("RESET")
	
func _process(delta):
	._process(delta)
	
	if not minigun_firing:
		return
	
	if minigun_rate_fire.is_stopped():
		_sound.stream = _firing_sounds[rand_range(0, _firing_sounds.size() - 1)]
		_sound.play()
		
		var bullet = preload("res://entity/projectile/mg_bullet/mg_bullet.tscn").instance()
		bullet.player = player
		bullet.is_master = is_master
		add_child(bullet)
		bullet.attack_damage = int(rand_range(2,6))
		bullet.spread = 0.40
		bullet.translation = _projectile_spawn_pos.global_transform.origin
		bullet.launch(_projectile_target_pos.global_transform.origin)
		
		minigun_rate_fire.start()
		
	
func _play_firing_animation():
	._play_firing_animation()
	_animation_player.play("firing")
	
func _spawn_projectile_to(_target : BaseEntity):
	._spawn_projectile_to(_target)
	minigun_firing = true
	
