extends Spatial
class_name BaseProjectile

const MAX_DISTANCE = 100.0

export var collision_shape : Resource

# identity owner
var player:PlayerData

var attack_damage : int = 0
var is_master = false
var show_projectile = false setget _set_show

# speed
var speed = 15.0
var spread = 0.8
var travel_distance = 0.0

var velocity = Vector3.ZERO

func _ready():
	set_as_toplevel(true)
	set_process(false)
	
func _set_show(val :bool):
	show_projectile = val
	set_process(show_projectile)
	visible = show_projectile
	
func launch(to : Vector3):
	to.z += rand_range(-spread, spread)
	to.x += rand_range(-spread, spread)
	to.y += rand_range(0.0, spread)
	velocity = translation.direction_to(to)
	look_at(to, Vector3.UP)
	_set_show(true)
	
func _process(delta):
	if not show_projectile:
		stop_projectile()
		return
		
	var _distance = speed * delta
	translation += velocity * _distance
	travel_distance += _distance
	
	if travel_distance > MAX_DISTANCE:
		stop_projectile()
		return
		
	check_collision()
	
func check_collision():
	var query = PhysicsShapeQueryParameters.new()
	query.set_shape(collision_shape)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.collision_mask = 1
	query.transform = global_transform
	
	var results: Array = get_world().direct_space_state.intersect_shape(query, 1)
	for result in results:
		validate_collider(result["collider"])
		return
	
func validate_collider(body):
	if not show_projectile:
		return
		
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
	show_projectile = false
	set_process(show_projectile)
	visible = show_projectile
	travel_distance = 0.0
	
	
	
