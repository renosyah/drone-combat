extends BaseHull

onready var _turret_pos = $turret_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/MeshInstance.set_surface_material(0, _material)
	spawn_turret()
		
func spawn_turret():
	if not _turret and turret_scene:
		var _turret_asset = turret_scene.instance()
		_turret_asset.weapon_scene = weapon_scene
		_turret_asset.sensor_scene = sensor_scene
		_turret_asset.color = color
		add_child(_turret_asset)
		_turret = _turret_asset
		_turret.translation = _turret_pos.translation
		_turret.rotate_y(180)
		
	.spawn_turret()
