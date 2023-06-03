extends BaseProjectile

var target :BaseHull

var _explosion :Explosion

func _ready():
	attack_damage = int(rand_range(52,68))
	
	_explosion = preload("res://assets/other/explosion/explosion.tscn").instance()
	get_parent().add_child(_explosion)
	_explosion.set_as_toplevel(true)
	
func stop_projectile():
	.stop_projectile()
	_explosion.translation = translation
	_explosion.explode()
	
func seek():
	var direction = global_transform.origin.direction_to(target.global_transform.origin)
	var desired = direction * speed
	return (desired - velocity).normalized() * 50.0
	
func _process(delta):
	if not is_instance_valid(target):
		._process(delta)
		return
		
	var _distance = speed * delta
	translation += velocity * _distance
	travel_distance += _distance
	
	velocity += seek() * delta
	look_at(target.global_transform.origin,Vector3.UP)
	global_transform.origin += velocity * delta
	if travel_distance > MAX_DISTANCE:
		stop_projectile()
		return
		
	check_collision()


















