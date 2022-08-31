extends BaseHull

onready var _turret_pos = $turret_pos
onready var _hpBar = $hpBar

remotesync func _take_damage(_damage : int):
	._take_damage(_damage)
	_hpBar.visible = true
	_hpBar.update_bar(hp, max_hp)
	
remotesync func _reset():
	._reset()
	_hpBar.update_bar(hp, max_hp)
	
remotesync func _dead():
	._dead()
	_hpBar.update_bar(0, max_hp)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/MeshInstance.set_surface_material(0, _material)
	.spawn_turret(_turret_pos.translation)
	
	_hpBar.update_bar(hp, max_hp)
	_hpBar.set_player_name(player_name)
	_hpBar.visible = false
