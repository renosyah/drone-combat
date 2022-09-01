extends Control

signal on_module_choosed(_module_scene)

export var modules : Array = []
export var title:String = "Module"

onready var _holder = $VBoxContainer/ScrollContainer/HBoxContainer/holder
onready var _item_module_template = preload("res://assets/ui/choose-module/module_item/module_item.tscn")
onready var _title = $VBoxContainer/Control/HBoxContainer/title

func show_modules():
	_title.text = title
	
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for module in modules:
		if not module is Dictionary:
			continue
			
		var item = _item_module_template.instance()
		item.data = module["data"]
		item.icon = module["icon"]
		_holder.add_child(item)
		item.connect("on_module_choosed", self, "_on_module_choosed")
		
func _on_module_choosed(_module_scene:String):
	emit_signal("on_module_choosed", _module_scene)
	
	
func _on_button_close_pressed():
	visible = false
