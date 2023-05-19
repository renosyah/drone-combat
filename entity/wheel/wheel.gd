extends MeshInstance
class_name BaseWheel

export var rotate_speed = 0.012
var spin: bool = false setget _set_spin

func _set_spin(val :bool):
	spin = val
	set_process(spin)

func set_color(color:Color):
	var _material = $MeshInstance8.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$MeshInstance8.set_surface_material(0, _material)
	$MeshInstance9.set_surface_material(0, _material)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(rad2deg(rotate_speed) * delta)
