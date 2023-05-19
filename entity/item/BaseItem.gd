extends Area
class_name BaseItem

var life_time :float = 65.0

var _altitude: float = 0.3
var _lifetime_timeout :Timer

func _ready():
	connect("body_entered", self,"_on_body_entered")
	
	_lifetime_timeout = Timer.new()
	add_child(_lifetime_timeout)
	_lifetime_timeout.wait_time = life_time
	_lifetime_timeout.autostart = false
	_lifetime_timeout.one_shot = true
	_lifetime_timeout.connect("timeout", self, "_on_lifetime_timeout")
	_lifetime_timeout.start()
	
func _process(delta):
	if int(round(translation.y)) > int(_altitude):
		translation.y -= 9.0 * delta
	
func _on_lifetime_timeout():
	set_process(false)
	queue_free()
	
func _on_body_entered(body):
	if not is_instance_valid(body):
		return
		
	if body.is_a_parent_of(self):
		return
		
	if body is GameplayCamera:
		return
		
	if body is StaticBody:
		return
		
	if not body is BaseHull:
		return
		
	on_picked_up_by(body)
	
	
func on_picked_up_by(body :BaseHull):
	set_process(false)
	queue_free()
	
	
