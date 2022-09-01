extends VBoxContainer

signal on_module_choosed(_module_data)

var module_data :DroneModuleData
onready var _image_module = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	_image_module.texture = load(module_data.icon)
	
func _on_mount_pressed():
	emit_signal("on_module_choosed", module_data)
