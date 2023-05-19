extends BaseHull

onready var _turret_pos = $turret_pos
onready var _wheels = [
	$pivot/wheel,
	$pivot/wheel1,
	$pivot/wheel2,
	$pivot/wheel3,
	$pivot/wheel4,
	$pivot/wheel5,
	$pivot/wheel6,
	$pivot/wheel7,
	$pivot/wheel8,
	$pivot/wheel9,
]
onready var _fire = $fire

func _each_wheel(spin :bool):
	for wheel in _wheels:
		wheel.spin = spin
	
func _set_puppet_moving_state(_val : int):
	._set_puppet_moving_state(_val)
	if is_dead:
		return
		
	match _moving_state:
		IDDLE:
			_each_wheel(false)
		MOVING:
			_each_wheel(true)
		NONE:
			pass
			
remotesync func _dead(_kill_by :Dictionary):
	._dead(_kill_by)
	_each_wheel(false)
	_fire.is_burning = true
	
remotesync func _reset():
	._reset()
	_fire.is_burning = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var _material = $pivot/body/MeshInstance.get_surface_material(0).duplicate()
	_material.albedo_color = color
	$pivot/body/MeshInstance.set_surface_material(0, _material)
	.spawn_turret(_turret_pos.translation)
	for w in _wheels:
		w.set_color(color)
		
	_each_wheel(false)
	
	
func moving(_delta):
	.moving(_delta)
	
	for wheel in _wheels:
		wheel.rotate_speed = 0.15 * direction.length()
	
	
	
	
