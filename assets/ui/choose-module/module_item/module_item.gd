extends VBoxContainer

signal on_module_choosed(_module_scene)

export var data :String = ""
export var icon :String = ""

onready var _image_module = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if icon.empty():
		return
		
	_image_module.texture = load(icon)
	
func _on_mount_pressed():
	emit_signal("on_module_choosed", data)
