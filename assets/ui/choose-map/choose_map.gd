extends Control

signal on_map_choosed(_map_data)

const _item_map_template = preload("res://assets/ui/choose-map/map_item/map_item.tscn")

export var current_map_id :String = ""
export var maps: Array = []
export var title:String = "Map"

onready var _holder = $VBoxContainer/ScrollContainer/HBoxContainer/holder
onready var _title = $VBoxContainer/Control/SafeArea/HBoxContainer/title

func show_maps():
	_title.text = title
		
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for m in maps:
		var map :MapData = MapData.new()
		map.from_dictionary(m)
		var item = _item_map_template.instance()
		item.map_data = map
		_holder.add_child(item)
		item.connect("on_map_choosed", self, "_on_map_choosed")
		
func _on_map_choosed(map :MapData):
	emit_signal("on_map_choosed", map.to_dictionary())
	_on_button_close_pressed()
	
func _on_button_close_pressed():
	visible = false
