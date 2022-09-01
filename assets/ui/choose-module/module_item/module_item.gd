extends VBoxContainer

const BUTTON_ENABLE_COLOR = Color(0, 0.592157, 0.035294)
const BUTTON_DISABLE_COLOR = Color(0.27451, 0.27451, 0.27451)

signal on_module_choosed(_module_data)

var enable_mount :bool = true
var module_data :DroneModuleData

onready var _module_name = $Control/VBoxContainer/MarginContainer/VBoxContainer/module_name
onready var _module_info = $Control/VBoxContainer/MarginContainer/VBoxContainer/module_info
onready var _module_image = $Control/module_icon

onready var _button_mount = $mount
onready var _button_color = $mount/ColorRect
onready var _button_label =  $mount/Label

onready var _info_holder = $Control/VBoxContainer/MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_module_name.text = module_data.module_name
	
	for info in module_data.infos:
		var dup = _module_info.duplicate()
		dup.text = info
		dup.visible = true
		_info_holder.add_child(dup)
		
	_module_image.texture = load(module_data.icon)
	
	if enable_mount:
		_button_mount.disabled = true
		_button_color.color = BUTTON_DISABLE_COLOR
	else:
		_button_mount.disabled = false
		_button_color.color = BUTTON_ENABLE_COLOR
	
	
func _on_mount_pressed():
	emit_signal("on_module_choosed", module_data)
	
	
	
	
	
	
	
	

