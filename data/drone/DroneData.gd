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
		"module_name" : "Twin .50 cal" ,
		"scene" : "res://entity/weapons/twin_mg/twin_mg.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_4.png",
		"infos" : [
			"High Firing Rate",
			"Low Damage",
			"Double Projectile"
		],
		"modifier" : {}
	},
	{
		"module_id":"w-3",
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
		"module_id":"w-4",
		"module_name" : "ZMB Minigun" ,
		"scene" : "res://entity/weapons/minigun/minigun.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_5.png",
		"infos" : [
			"Insane Firing Rate",
			"Very Low Damage"
		],
		"modifier" : {}
	},
	{
		"module_id":"w-5",
		"module_name" : "75mm A.T." ,
		"scene" : "res://entity/weapons/cannon/cannon.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_3.png",
		"infos" : [
			"Slow Firing Rate",
			"Very High Damage"
		],
		"modifier" : {}
	},
	{
		"module_id":"w-6",
		"module_name" : "90mm Launcher" ,
		"scene" : "res://entity/weapons/smothbore/smothbore.tscn",
		"icon" : "res://assets/ui/choose-module/drone/weapon_6.png",
		"infos" : [
			"Slow Firing Rate",
			"High Damage",
			"Guided Munition"
		],
		"modifier" : {}
	}
]
const turrets :Array = [
	{
		"module_id":"t-1",
		"module_name" : "Mk 1 Auto",
		"scene" : "res://entity/drone_turrets/turret_1/turret_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_1.png",
		"infos" : [
			"Hp : 40",
			"Rotation : 120",
			"Ammo Capacity : 120"
		],
		"modifier" : {
			"turret_rotation_speed" : 120,
			"turret_hp" : 40,
			"turret_max_hp" : 40,
			"turret_ammo" : 120,
			"turret_max_ammo" : 120
		}
	},
	{
		"module_id":"t-2",
		"module_name" : "Mk 2 Cobra",
		"scene" : "res://entity/drone_turrets/turret_7/turret_7.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_7.png",
		"infos" : [
			"Hp : 60",
			"Rotation : 110",
			"Ammo Capacity : 140"
		],
		"modifier" : {
			"turret_rotation_speed" : 110,
			"turret_hp" : 60,
			"turret_max_hp" : 60,
			"turret_ammo" : 140,
			"turret_max_ammo" : 140
		}
	},
	{
		"module_id":"t-3",
		"module_name" : "A-12 Homogen",
		"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_3.png",
		"infos" : [
			"Hp : 90",
			"Rotation : 90",
			"Ammo Capacity : 200"
		],
		"modifier" : {
			"turret_rotation_speed" : 90,
			"turret_hp" : 90,
			"turret_max_hp" : 90,
			"turret_ammo" : 200,
			"turret_max_ammo" : 200
		}
	},
	{
		"module_id":"t-4",
		"module_name" : "A-14 Homulus",
		"scene" : "res://entity/drone_turrets/turret_4/turret_4.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_4.png",
		"infos" : [
			"Hp : 95",
			"Rotation : 70",
			"Ammo Capacity : 200"
		],
		"modifier" : {
			"turret_rotation_speed" : 70,
			"turret_hp" : 95,
			"turret_max_hp" : 95,
			"turret_ammo" : 200,
			"turret_max_ammo" : 200
		}
	},
	{
		"module_id":"t-5",
		"module_name" : "A-15 Sperict",
		"scene" : "res://entity/drone_turrets/turret_6/turret_6.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_6.png",
		"infos" : [
			"Hp : 100",
			"Rotation : 80",
			"Ammo Capacity : 300"
		],
		"modifier" : {
			"turret_rotation_speed" : 80,
			"turret_hp" : 100,
			"turret_max_hp" : 100,
			"turret_ammo" : 300,
			"turret_max_ammo" : 300
		}
	},
	{
		"module_id":"t-6",
		"module_name" : "Rectketa MX-A",
		"scene" : "res://entity/drone_turrets/turret_5/turret_5.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_2.png",
		"infos" : [
			"Hp : 140",
			"Rotation : 55",
			"Ammo Capacity : 500"
		],
		"modifier" : {
			"turret_rotation_speed" : 55,
			"turret_hp" : 140,
			"turret_max_hp" : 140,
			"turret_ammo" : 500,
			"turret_max_ammo" : 500
		}
	},
	{
		"module_id":"t-7",
		"module_name" : "Rectketa MX-B",
		"scene" : "res://entity/drone_turrets/turret_2/turret_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/turret_2.png",
		"infos" : [
			"Hp : 160",
			"Rotation : 45",
			"Ammo Capacity : 500"
		],
		"modifier" : {
			"turret_rotation_speed" : 45,
			"turret_hp" : 160,
			"turret_max_hp" : 160,
			"turret_ammo" : 500,
			"turret_max_ammo" : 500
		}
	},
]
const hulls :Array = [
	{
		"module_id":"h-1",
		"module_name" : "AM-A LT",
		"scene" : "res://entity/drone_hulls/hull_6/hull_6.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_6.png",
		"infos" : [
			"Hp : 120",
			"Speed : 4",
			"Travese : 2"
		],
		"modifier" : {
			"hp" : 120,
			"max_hp" : 120,
			"speed" : 4.0,
			"turning_speed" : 2.0
		}
	},
	{
		"module_id":"h-2",
		"module_name" : "AM-B Medium",
		"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_3.png",
		"infos" : [
			"Hp : 220",
			"Speed : 3",
			"Travese : 2"
		],
		"modifier" : {
			"hp" : 220,
			"max_hp" : 220,
			"speed" : 3.0,
			"turning_speed" : 2.0
		}
	},
	{
		"module_id":"h-3",
		"module_name" : "Lizard MK 2",
		"scene" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_2.png",
		"infos" : [
			"Hp : 80",
			"Speed : 5",
			"Travese : 3"
		],
		"modifier" : {
			"hp" : 80,
			"max_hp" : 80,
			"speed" : 5.0,
			"turning_speed" : 3.0
		}
	},
	{
		"module_id":"h-4",
		"module_name" : "Lizard X-AA",
		"scene" : "res://entity/drone_hulls/hull_5/hull_5.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_5.png",
		"infos" : [
			"Hp : 80",
			"Speed : 6",
			"Travese : 4"
		],
		"modifier" : {
			"hp" : 80,
			"max_hp" : 80,
			"speed" : 6.0,
			"turning_speed" : 4.0
		}
	},
	{
		"module_id":"h-5",
		"module_name" : "Rectketa UBM",
		"scene" : "res://entity/drone_hulls/hull_1/hull_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_1.png",
		"infos" : [
			"Hp : 320",
			"Speed : 2",
			"Travese : 3"
		],
		"modifier" : {
			"hp" : 320,
			"max_hp" : 320,
			"speed" : 2.0,
			"turning_speed" : 3.0
		}
	},
	{
		"module_id":"h-6",
		"module_name" : "Rectketa UBM-B",
		"scene" : "res://entity/drone_hulls/hull_4/hull_4.tscn",
		"icon" : "res://assets/ui/choose-module/drone/hull_4.png",
		"infos" : [
			"Hp : 440",
			"Speed : 2",
			"Travese : 2"
		],
		"modifier" : {
			"hp" : 440,
			"max_hp" : 440,
			"speed" : 2.0,
			"turning_speed" : 2.0
		}
	},
]
const sensors :Array = [
	{
		"module_id":"s-1",
		"module_name" : "Mk 1 Watchmen",
		"scene" : "res://entity/sensor/sensor_1/sensor_1.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_1.png",
		"infos" : [
			"Basic sensor",
			"Develop by Rectketa"
		],
		"modifier" : {
			"spotting_range" : 16,
			"scanning_speed" : 0.07
		}
	},
	{
		"module_id":"s-2",
		"module_name" : "Mk 2 Eagle",
		"scene" : "res://entity/sensor/sensor_2/sensor_2.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_2.png",
		"infos" : [
			"Standard sensor",
			"Develop by Rectketa"
		],
		"modifier" : {
			"spotting_range" : 17,
			"scanning_speed" : 0.06
		}
	},
	{
		"module_id":"s-3",
		"module_name" : "Mk 3 Raptor",
		"scene" : "res://entity/sensor/sensor_4/sensor_4.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_4.png",
		"infos" : [
			"Special sensor",
			"Develop by Rectketa"
		],
		"modifier" : {
			"spotting_range" : 18,
			"scanning_speed" : 0.08
		}
	},
	{
		"module_id":"s-4",
		"module_name" : "Mk 4 Hunter",
		"scene" : "res://entity/sensor/sensor_3/sensor_3.tscn",
		"icon" : "res://assets/ui/choose-module/drone/sensor_3.png",
		"infos" : [
			"Advance sensor",
			"Develop by Rectketa"
		],
		"modifier" : {
			"spotting_range" : 19,
			"scanning_speed" : 0.05
		}
	},
]

export var player_id:String = ""
export var player_name:String = ""

export var hp :int = 240
export var max_hp:int = 240

export var turret_hp :int = 120
export var turret_max_hp:int = 120

export var turret_ammo :int = 300
export var turret_max_ammo :int = 300

export var turret_rotation_speed = 65

export var speed:float = 2.0
export var turning_speed:float = 2.0

export var spotting_range :int = 16
export var scanning_speed:float = 0.07

var hull_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(hulls[0])
var turret_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(turrets[0])
var weapon_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(weapons[0])
var sensor_module:DroneModuleData = DroneModuleData.new().parse_from_dictionary(sensors[0])

export var color :Color = Color("#000080")

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
	turret_ammo = turret_module.modifier["turret_ammo"]
	turret_max_ammo = turret_module.modifier["turret_max_ammo"]

	weapon_module = DroneModuleData.new().parse_from_dictionary(data["weapon_module"])
	
	sensor_module = DroneModuleData.new().parse_from_dictionary(data["sensor_module"])
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
	data["sensor_module"] = sensor_module.to_dictionary()
	
	data["color"] = color
	
	return data
	
func spawn(player:PlayerData, _parent : Node, _at : Vector3) -> Node:
	var drone = load(hull_module.scene).instance()
	drone.player = player
	drone.drone_data = self
	_parent.add_child(drone)
	drone.translation = _at
	drone.name = player.player_id
	drone.set_network_master(Network.PLAYER_HOST_ID)
	return drone
	
