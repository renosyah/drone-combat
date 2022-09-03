extends Area
class_name BaseItem

func _ready():
	connect("body_entered", self,"_on_body_entered")
	
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
	queue_free()
