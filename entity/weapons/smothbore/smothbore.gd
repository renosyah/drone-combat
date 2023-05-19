extends BaseWeapon

onready var _projectile_spawn_pos = $projectile_spawn_pos
onready var _projectile_target_pos = $projectile_target_pos
onready var _animation_player = $AnimationPlayer
onready var _firing_sounds = [
	preload("res://entity/weapons/cannon/cannon_firing_1.wav"),
	preload("res://entity/weapons/cannon/cannon_firing_2.wav"),
	preload("res://entity/weapons/cannon/cannon_firing_3.wav")
]

func _play_firing_animation():
	._play_firing_animation()
	_animation_player.play("firing")
	
	_sound.stream = _firing_sounds[rand_range(0, _firing_sounds.size() - 1)]
	_sound.play()
	
func _spawn_projectile_to(_target : BaseEntity):
	._spawn_projectile_to(_target)
	var bullet = get_bullet_from_pool()
	bullet.target = _target
	bullet.speed = 1.25
	bullet.translation = _projectile_spawn_pos.global_transform.origin
	bullet.launch(_projectile_target_pos.global_transform.origin)
