extends BaseProjectile

var _explosion :Explosion

func _ready():
	attack_damage = int(rand_range(62,98))
	
	_explosion = preload("res://assets/other/explosion/explosion.tscn").instance()
	get_parent().add_child(_explosion)
	_explosion.set_as_toplevel(true)
	
func stop_projectile():
	.stop_projectile()
	_explosion.translation = translation
	_explosion.explode()
	
