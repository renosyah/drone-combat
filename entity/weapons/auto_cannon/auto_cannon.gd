extends BaseWeapon

onready var _projectile_spawn_pos = $projectile_spawn_pos
onready var _projectile_target_pos = $projectile_target_pos
onready var _animation_player = $AnimationPlayer
onready var _firing_sounds = [
	preload("res://entity/weapons/auto_cannon/auto_cannon_firing_1.wav"),
	preload("res://entity/weapons/auto_cannon/auto_cannon_firing_2.wav"),
	preload("res://entity/weapons/auto_cannon/auto_cannon_firing_3.wav")
]

func _ready():
	attack_delay = 0.4
	
func _play_firing_animation():
	._play_firing_animation()
	_animation_player.play("firing")
	
	_sound.stream = _firing_sounds[rand_range(0, _firing_sounds.size() - 1)]
	_sound.play()
	
func _spawn_projectile_to(direction : Vector3):
	._spawn_projectile_to(direction)
	var bullet = preload("res://entity/projectile/med_caliber/med_caliber.tscn").instance()
	bullet.is_master = is_master
	add_child(bullet)
	bullet.attack_damage = int(rand_range(12,14))
	bullet.spread = 0.23
	bullet.translation = _projectile_spawn_pos.global_transform.origin
	bullet.launch(_projectile_target_pos.global_transform.origin)
	
