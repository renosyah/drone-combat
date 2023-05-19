extends BaseTurret

onready var weapon_pos = $pivot/weapon/weapon_pos
onready var sensor_pos = $pivot/sensor_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/MeshInstance.set_surface_material(0,_material)
	
	.spawn_weapon($pivot/weapon, weapon_pos.translation)
	.spawn_sensor(sensor_pos.translation)
