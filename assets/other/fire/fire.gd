extends Spatial

onready var _fire = $fire

var is_burning = false setget _set_is_burning
	
func _set_is_burning(val :bool):
	is_burning = val
	_fire.emitting = is_burning
		
func _ready():
	_set_is_burning(false)
