extends RayCast
class_name BaseProjectile

const MAX_DISTANCE = 100.0

# identity owner
var player:PlayerData

var attack_damage : int = 0
var is_master = false

# speed
var speed = 15.0
var spread = 0.8
var travel_distance = 0.0

var velocity = Vector3.ZERO

func _ready():
	enabled = true
	cast_to = Vector3(0, 0, -0.3)
	set_as_toplevel(true)
	set_process(true)

func launch(to : Vector3):
	to.z += rand_range(-spread, spread)
	to.x += rand_range(-spread, spread)
	to.y += rand_range(0.0, spread)
	velocity = translation.direction_to(to)
	look_at(to, Vector3.UP)
	
func _process(delta):
	var _distance = speed * delta
	translation += velocity * _distance
	travel_distance += _distance
	
	validate_collider()
	
	if travel_distance > MAX_DISTANCE:
		stop_projectile()
	
func validate_collider():
	if not is_colliding():
		return
		
	var body = get_collider()
	if not is_instance_valid(body):
		return
		
	if body is GameplayCamera:
		return
		
	if body is StaticBody:
		stop_projectile()
		return
		
	if not body is BaseEntity:
		return
		
	if not body.has_method("take_damage"):
		return
		
	if is_master:
		body.take_damage(attack_damage, player)
	
	stop_projectile()
	
func stop_projectile():
	set_process(false)
	queue_free()
	
	
	
