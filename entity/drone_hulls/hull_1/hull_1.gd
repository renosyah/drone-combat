extends BaseHull

onready var _turret_pos = $turret_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/MeshInstance.set_surface_material(0, _material)
	.spawn_turret(_turret_pos.translation)
