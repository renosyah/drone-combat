extends BaseData
class_name DroneData

const weapons :Array = [
	{
		"module_id":"w-1",
		"module_name" : ".50 cal HMG",
		"scene" : "res://entity/weapons/mg/mg.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_1.png",
		"infos" : [
			"High Firing Rate",
			"Low Damage"
		],
		"modifier" : {}
	},
	{
		"module_id":"w-2",
		"module_name" : "30mm auto",
		"scene" : "res://entity/weapons/auto_cannon/auto_cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_2.png",
		"infos" : [
			"Mid Firing Rate",
			"Mid Damage"
		],
		"modifier" : {}
	},
	{
		"module_id":"w-3",
		"module_name" : "75mm AD" ,
		"scene" : "res://entity/weapons/cannon/cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_3.png",
		"infos" : [
			"Slow Firing Rate",
			"High Damage"
		],
		"modifier" : {}
	}
]
const turrets :Array = [
	{
		"module_id":"t-1",
		"module_name" : "Mk 1 auto",
		"scene" : "res://entity/drone_turrets/turret_1/turret_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_1.png",
		"infos" : [
			"Hp : 20",
			"Rotation : 90"
		],
		"modifier" : {
			"turret_rotation_speed" : 90,
			"turret_hp" : 20,
			"turret_max_hp" : 20
		}
	},
	{
		"module_id":"t-2",
		"module_name" : "Recta mx-B",
		"scene" : "res://entity/drone_turrets/turret_2/turret_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_2.png",
		"infos" : [
			"Hp : 120",
			"Rotation : 70"
		],
		"modifier" : {
			"turret_rotation_speed" : 70,
			"turret_hp" : 90,
			"turret_max_hp" : 90
		}
	},
	{
		"module_id":"t-3",
		"module_name" : "A-12 Homogen",
		"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_3.png",
		"infos" : [
			"Hp : 60",
			"Rotation : 80"
		],
		"modifier" : {
			"turret_rotation_speed" : 80,
			"turret_hp" : 60,
			"turret_max_hp" : 60
		}
	}
]
const hulls :Array = [
	{
		"module_id":"h-1",
		"module_name" : "Heavy Hull",
		"scene" : "res://entity/drone_hulls/hull_1/hull_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_1.png",
		"infos" : [
			"Hp : 240",
			"Speed : 2",
			"Travese : 2"
		],
		"modifier" : {
			"hp" : 240,
			"max_hp" : 240,
			"speed" : 2.0,
			"turning_speed" : 2.0
		}
	},
	{
		"module_id":"h-2",
		"module_name" : "Armored Car Hull",
		"scene" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_2.png",
		"infos" : [
			"Hp : 40",
			"Speed : 4",
			"Travese : 3"
		],
		"modifier" : {
			"hp" : 40,
			"max_hp" : 40,
			"speed" : 4.0,
			"turning_speed" : 3.0
		}
	},
	{
		"module_id":"h-3",
		"module_name" : "Medium Hull",
		"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_3.png",
		"infos" : [
			"Hp : 90",
			"Speed : 2.5",
			"Travese : 2.0"
		],
		"modifier" : {
			"hp" : 90,
			"max_hp" : 90,
			"speed" : 2.5,
			"turning_speed" : 2.0
		}
	}
]
const sensors :Array = [
	{
		"module_id":"s-1",
		"module_name" : "Mk 1 sensor",
		"scene" : "res://entity/sensor/sensor_1/sensor_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_1.png",
		"infos" : [
			"+- Range",
		],
		"modifier" : {
			"spotting_range" : 16,
			"scanning_speed" : 0.07
		}
	},
]

export var player_id:String = ""
export var player_name:String = ""

export var hp :int = 120
export var max_hp:int = 120

export var turret_hp :int = 80
export var turret_max_hp:int = 80

export var turret_rotation_speed = 90

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
	
	hull_module = DroneModuleData.new().parse_from_dictionary(data["hull_module"])
	hp = hull_module.modifier["hp"]
	max_hp = hull_module.modifier["max_hp"]
	speed = hull_module.modifier["speed"]
	turning_speed = hull_module.modifier["turning_speed"]
	
	turret_module = DroneModuleData.new().parse_from_dictionary(data["turret_module"])
	turret_rotation_speed = turret_module.modifier["turret_rotation_speed"]
	turret_hp = turret_module.modifier["turret_hp"]
	turret_max_hp = turret_module.modifier["turret_max_hp"]
	
	weapon_module = DroneModuleData.new().parse_from_dictionary(data["weapon_module"])
	
	sensor_module = DroneModuleData.new().parse_from_dictionary(data["sensor_module "])
	spotting_range = sensor_module.modifier["spotting_range"]
	scanning_speed = sensor_module.modifier["scanning_speed"]
	
	color = data["color"]
	
	
func to_dictionary() -> Dictionary :
	var data : Dictionary = {}
	data["player_id"] = player_id
	data["player_name"] = player_name
	
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
	
