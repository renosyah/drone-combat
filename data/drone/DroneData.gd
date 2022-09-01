extends BaseData
class_name DroneData

const weapons :Array = [
	{
		"module_name" : ".50 cal MG",
		"scene" : "res://entity/weapons/mg/mg.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_1.png"
	},
	{
		"module_name" : "20mm auto",
		"scene" : "res://entity/weapons/auto_cannon/auto_cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_2.png"
	},
	{
		"module_name" : "75mm AD" ,
		"scene" : "res://entity/weapons/cannon/cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_3.png"
	}
]
const turrets :Array = [
	{
		"module_name" : "Mk 1 auto",
		"scene" : "res://entity/drone_turrets/turret_1/turret_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_1.png"
	},
	{
		"module_name" : "Recta mx-B",
		"scene" : "res://entity/drone_turrets/turret_2/turret_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_2.png"
	},
	{
		"module_name" : "A-12 Homogen",
		"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_3.png"
	}
]
const hulls :Array = [
	{
		"module_name" : "Heavy Hull",
		"scene" : "res://entity/drone_hulls/hull_1/hull_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_1.png"
	},
	{
		"module_name" : "Armored Car Hull",
		"scene" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_2.png"
	},
	{
		"module_name" : "Medium Hull",
		"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_3.png"
	}
]
const sensors :Array = [
	{
		"module_name" : "Mk 1 sensor",
		"scene" : "res://entity/sensor/sensor_1/sensor_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_1.png"
	},
]

export var player_id:String = ""
export var player_name:String = ""

export var hp :int = 120
export var max_hp:int = 120

export var turret_hp :int = 80
export var turret_max_hp:int = 80

export var speed:float = 2.0
export var turning_speed:float = 4.0

export var spotting_range :int = 16
export var scanning_speed:float = 0.07

var hull_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(hulls[0])
var turret_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(turrets[0])
var weapon_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(weapons[0])
var sensor_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(sensors[0])

export var color :Color = Color.gray


func from_dictionary(data : Dictionary):
	.from_dictionary(data)
	
	if data.empty():
		return
		
	player_id = data["player_id"]
	player_name = data["player_name"]
	
	hp = data["hp"]
	max_hp = data["max_hp"]
	
	turret_hp = data["turret_hp "]
	turret_max_hp = data["turret_max_hp"]
	
	speed = data["speed"]
	turning_speed = data["turning_speed"]
	
	spotting_range = data["spotting_range"]
	scanning_speed = data["scanning_speed"]
	
	hull_module = DroneModuleData.new().parse_from_dictionary(data["hull_module"])
	turret_module = DroneModuleData.new().parse_from_dictionary(data["turret_module"])
	weapon_module = DroneModuleData.new().parse_from_dictionary(data["weapon_module"])
	sensor_module =DroneModuleData.new().parse_from_dictionary( data["sensor_module "])
	
	color = data["color"]
	
	
func to_dictionary() -> Dictionary :
	var data : Dictionary = {}
	data["player_id"] = player_id
	data["player_name"] = player_name
	
	data["hp"] = hp
	data["max_hp"] = max_hp
	
	data["turret_hp "] = turret_hp
	data["turret_max_hp"] = turret_max_hp
	
	data["speed"] = speed
	data["turning_speed"] = turning_speed
	
	data["spotting_range"] = spotting_range
	data["scanning_speed"] = scanning_speed
	
	data["hull_module"] = hull_module.to_dictionary()
	data["turret_module"] = turret_module.to_dictionary()
	data["weapon_module"] = weapon_module.to_dictionary()
	data["sensor_module "] = sensor_module.to_dictionary()
	
	data["color"] = color
	
	return data
	
func spawn(node_name : String, _parent : Node, _at : Vector3) -> Node:
	var drone = load(hull_module.scene).instance()
	drone.drone_data = self
	_parent.add_child(drone)
	drone.translation = _at
	drone.name = node_name
	drone.set_network_master(Network.PLAYER_HOST_ID)
	return drone
	
