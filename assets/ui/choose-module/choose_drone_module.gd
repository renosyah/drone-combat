extends Control

signal on_module_choosed(_module_scene)

const _item_module_template = preload("res://assets/ui/choose-module/module_item/module_item.tscn")

export var current_module_id :String = ""
export var modules : Array = []
export var title:String = "Module"

onready var _holder = $VBoxContainer/ScrollContainer/HBoxContainer/holder
onready var _title = $VBoxContainer/Control/SafeArea/HBoxContainer/title

func show_modules():
	_title.text = title
		
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for m in modules:
		var module :DroneModuleData = DroneModuleData.new().parse_from_dictionary(m)
		var item = _item_module_template.instance()
		item.module_data = module
		item.enable_mount = (current_module_id != module.module_id)
		_holder.add_child(item)
		item.connect("on_module_choosed", self, "_on_module_choosed")
		
func _on_module_choosed(_module :DroneModuleData):
	emit_signal("on_module_choosed", _module)
	
func _on_button_close_pressed():
	visible = false
