extends BaseData
class_name DroneData

const drone_hulls = [
	"res://entity/drone_hulls/hull_1/hull_1.tscn",
	"res://entity/drone_hulls/hull_2/hull_2.tscn",
	"res://entity/drone_hulls/hull_3/hull_3.tscn",
	"res://entity/drone_hulls/hull_1/hull_1.tscn",
]
const drone_turrets = [
	"res://entity/drone_turrets/turret_1/turret_1.tscn",
	"res://entity/drone_turrets/turret_2/turret_2.tscn",
	"res://entity/drone_turrets/turret_3/turret_3.tscn",
	"res://entity/drone_turrets/turret_1/turret_1.tscn",
]
const drone_weapons = [
	"res://entity/weapons/mg/mg.tscn",
	"res://entity/weapons/cannon/cannon.tscn",
	"res://entity/weapons/auto_cannon/auto_cannon.tscn",
	"res://entity/weapons/mg/mg.tscn",
]
const drone_sensors = [
	"res://entity/sensor/sensor_1/sensor_1.tscn"
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

export var hull_scene:String = "res://entity/drone_hulls/hull_1/hull_1.tscn"
export var turret_scene:String = "res://entity/drone_turrets/turret_2/turret_2.tscn"
export var weapon_scene:String = "res://entity/weapons/auto_cannon/auto_cannon.tscn"
export var sensor_scene:String = "res://entity/sensor/sensor_1/sensor_1.tscn"
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
	
	hull_scene = data["hull_scene"]
	turret_scene = data["turret_scene"]
	weapon_scene = data["weapon_scene"]
	sensor_scene = data["sensor_scene "]
	
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
	
	data["hull_scene"] = hull_scene
	data["turret_scene"] = turret_scene
	data["weapon_scene"] = weapon_scene
	data["sensor_scene "] = sensor_scene
	
	data["color"] = color
	
	return data
	
func spawn(name : String, _parent : Node, _at : Vector3) -> Node:
	var drone = load(hull_scene).instance()
	
	drone.player_id = player_id
	drone.player_name = player_name
	
	drone.hp = hp
	drone.max_hp = max_hp
	
	drone.speed = speed
	drone.turning_speed = turning_speed

	drone.turret_hp = turret_hp
	drone.turret_max_hp = turret_max_hp

	drone.spotting_range = spotting_range
	drone.scanning_speed = scanning_speed

	drone.turret_scene = load(turret_scene)
	drone.weapon_scene = load(weapon_scene)
	drone.sensor_scene = load(sensor_scene)
	
	drone.color = color
	_parent.add_child(drone)
	drone.translation = _at
	drone.name = name
	drone.set_network_master(Network.PLAYER_HOST_ID)
	return drone
	
