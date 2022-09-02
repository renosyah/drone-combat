extends Area
class_name BaseProjectile

const MAX_DISTANCE = 180.0

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
	set_as_toplevel(true)

func launch(to : Vector3):
	to.z += rand_range(-spread, spread)
	to.x += rand_range(-spread, spread)
	to.y += rand_range(-spread, spread + spread * 0.25)
	velocity = translation.direction_to(to)
	look_at(to, Vector3.UP)
	
func _process(delta):
	var _distance = speed * delta
	translation += velocity * _distance
	travel_distance += _distance
	
	if travel_distance > MAX_DISTANCE:
		stop_projectile()
		queue_free()
	
func _on_projectile_body_entered(body):
	if not is_instance_valid(body):
		return
		
	if body.is_a_parent_of(self):
		return
		
	if body is GameplayCamera:
		return
		
	if body is StaticBody:
		stop_projectile()
		queue_free()
		return
		
	if not body is BaseEntity:
		return
		
	if not body.has_method("take_damage"):
		return
		
	if is_master:
		body.take_damage(attack_damage, player)
	
	stop_projectile()
	queue_free()
	
func stop_projectile():
	set_process(false)
	
	
	
	
