extends Control

signal on_mission_choosed(_mission_data)

const _item_misson_template = preload("res://assets/ui/choose-mission/mission_item/mission_item.tscn")

export var missions: Array = []
export var title:String = "Campaign"

onready var _holder = $VBoxContainer/ScrollContainer/HBoxContainer/holder
onready var _title = $VBoxContainer/Control/SafeArea/HBoxContainer/title

func show_missions():
	_title.text = title
		
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for m in missions:
		var misson = SpMissionData.new()
		misson.from_dictionary(m)
		var item = _item_misson_template.instance()
		item.mission_data = misson
		_holder.add_child(item)
		item.connect("on_mission_choosed", self , "_on_mission_choosed")
		
func _on_mission_choosed(mission :SpMissionData):
	emit_signal("on_mission_choosed", mission)
	_on_button_close_pressed()
	
func _on_button_close_pressed():
	visible = false
