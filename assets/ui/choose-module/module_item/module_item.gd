extends VBoxContainer

signal on_module_choosed(_module_data)

var module_data :DroneModuleData

onready var _module_name = $Control/VBoxContainer/ColorRect/VBoxContainer/module_name
onready var _module_info = $Control/VBoxContainer/ColorRect/VBoxContainer/module_info
onready var _module_image = $Control/module_icon

onready var _info_holder = $Control/VBoxContainer/ColorRect/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_module_name.text = module_data.module_name
	
	for info in module_data.infos:
		var dup = _module_info.duplicate()
		dup.text = info
		dup.visible = true
		_info_holder.add_child(dup)
	
	_module_image.texture = load(module_data.icon)
	
func _on_mount_pressed():
	emit_signal("on_module_choosed", module_data)
