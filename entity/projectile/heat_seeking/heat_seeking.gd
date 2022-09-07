extends BaseProjectile

var target :BaseHull

func _ready():
	attack_damage = 85
	
func seek():
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
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
	
	validate_collider()
		
	if travel_distance > MAX_DISTANCE:
		stop_projectile()
		return



















