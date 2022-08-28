extends BaseWeapon

onready var _projectile_spawn_pos = $projectile_spawn_pos
onready var _projectile_target_pos = $projectile_target_pos
onready var _animation_player = $AnimationPlayer

func _ready():
	attack_delay = 0.1
	
func _play_firing_animation():
	._play_firing_animation()
	_animation_player.play("firing")
	pass
	
func _spawn_projectile_to(direction : Vector3):
	._spawn_projectile_to(direction)
	var bullet = preload("res://entity/projectile/mg_bullet/mg_bullet.tscn").instance()
	bullet.is_master = is_master
	add_child(bullet)
	bullet.translation = _projectile_spawn_pos.global_transform.origin
	bullet.launch(_projectile_target_pos.global_transform.origin)
	
