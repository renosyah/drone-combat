extends Node
class_name TweenRotation

var rotation_degree :float = 0.0
var target :Spatial

func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_instance_valid(target):
		set_process(false)
		return
		
	target.rotation.y = lerp_angle(target.rotation.y, deg2rad(rotation_degree), delta * 5)
