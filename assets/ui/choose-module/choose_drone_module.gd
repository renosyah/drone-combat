extends Control

signal on_module_choosed(_module_scene)

const _item_module_template = preload("res://assets/ui/choose-module/module_item/module_item.tscn")

onready var weapons :Array = [
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : ".50 cal MG",
		"scene" : "res://entity/weapons/mg/mg.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_1.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "20mm auto",
		"scene" : "res://entity/weapons/auto_cannon/auto_cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_2.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "75mm AD" ,
		"scene" : "res://entity/weapons/cannon/cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_3.png"
	})
]
onready var turrets :Array = [
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Mk 1 auto",
		"scene" : "res://entity/drone_turrets/turret_1/turret_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_1.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Recta mx-B",
		"scene" : "res://entity/drone_turrets/turret_2/turret_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_2.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "A-12 Homogen",
		"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_3.png"
	})
]
onready var hulls :Array = [
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Heavy Hull",
		"scene" : "res://entity/drone_hulls/hull_1/hull_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_1.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Armored Car Hull",
		"scene" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_2.png"
	}),
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Medium Hull",
		"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_3.png"
	})
]
onready var sensors :Array = [
	DroneModuleData.new().parse_from_dictionary({
		"module_name" : "Mk 1 sensor",
		"scene" : "res://entity/sensor/sensor_1/sensor_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_1.png"
	}),
]

export var modules : Array = []
export var title:String = "Module"

onready var _holder = $VBoxContainer/ScrollContainer/HBoxContainer/holder
onready var _title = $VBoxContainer/Control/HBoxContainer/title

func show_modules():
	_title.text = title
		
	for child in _holder.get_children():
		_holder.remove_child(child)
		
	for module in modules:
		if not module is DroneModuleData:
			continue
			
		var item = _item_module_template.instance()
		item.module_data = module
		_holder.add_child(item)
		item.connect("on_module_choosed", self, "_on_module_choosed")
		
func _on_module_choosed(_module: DroneModuleData):
	emit_signal("on_module_choosed", _module)
	
	
func _on_button_close_pressed():
	visible = false
