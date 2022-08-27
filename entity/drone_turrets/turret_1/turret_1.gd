extends BaseTurret

onready var weapon_pos = $pivot/weapon/weapon_pos
onready var sensor_pos = $pivot/sensor_pos

func spawn_weapon():
	if not _weapon and weapon_scene:
		var _weapon_asset = weapon_scene.instance()
		head.add_child(_weapon_asset)
		_weapon = _weapon_asset
		_weapon.translation = weapon_pos.translation
		
	.spawn_weapon()
	
func spawn_sensor():
	if not _sensor and sensor_scene:
		var _sensor_asset = sensor_scene.instance()
		add_child(_sensor_asset)
		_sensor = _sensor_asset
		_sensor.translation = sensor_pos.translation
		_sensor.add_exception(self)
		_sensor.add_exception(get_parent())
		
	.spawn_sensor()
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/MeshInstance.set_surface_material(0, _material)
	$pivot/MeshInstance2.set_surface_material(0, _material)
	
	spawn_weapon()
	spawn_sensor()
