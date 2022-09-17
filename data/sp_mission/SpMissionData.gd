extends BaseData
class_name SpMissionData

const MISSIONS :Array = [
	{
		"mission_id": "chapter-1_mission-1",
		"mission_index": 0,
		"mission_name": "Warm Up",
		"mission_objective": "Defeat Enemy Drone",
		"mission_map": MapData.MAPS[0],
		"mission_bot_drones": [
			{
				"player" : {
					"player_id" : "bot-1",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-1",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
		],
		"unlocked_module": {},
		"unlocked_map": {}
	},
	{
		"mission_id": "chapter-1_mission-2",
		"mission_index": 1,
		"mission_name": "Friend In Need",
		"mission_objective": "Assist Heikal",
		"mission_map": MapData.MAPS[0],
		"mission_bot_drones": [
			{
				"player" : {
					"player_id" : "bot-1",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-1",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
			{
				"player" : {
					"player_id" : "bot-2",
					"player_name" : "Heikal",
					"player_team" : 0,
				},
				"drone_data" : {
					"player_id": "bot-2",
					"player_name": "Heikal",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[1],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.blue
				}
			},
		],
		"unlocked_module": DroneData.turrets[1],
		"unlocked_map": {}
	},
	{
		"mission_id": "chapter-1_mission-3",
		"mission_index": 2,
		"mission_name": "Ambush",
		"mission_objective": "Assist Heikal & Cobra",
		"mission_map": MapData.MAPS[0],
		"mission_bot_drones": [
			{
				"player" : {
					"player_id" : "bot-1",
					"player_name" : "Cobra",
					"player_team" : 0,
				},
				"drone_data" : {
					"player_id": "bot-1",
					"player_name": "Cobra",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[1],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.blue
				}
			},
			{
				"player" : {
					"player_id" : "bot-2",
					"player_name" : "Heikal",
					"player_team" : 0,
				},
				"drone_data" : {
					"player_id": "bot-2",
					"player_name": "Heikal",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[1],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.blue
				}
			},
						{
				"player" : {
					"player_id" : "bot-3",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-3",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
			{
				"player" : {
					"player_id" : "bot-4",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-4",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
		],
		"unlocked_module": {},
		"unlocked_map": {}
	},
	{
		"mission_id": "chapter-1_mission-4",
		"mission_index": 3,
		"mission_name": "Retake",
		"mission_objective": "Defeat All Enemy Drones",
		"mission_map": MapData.MAPS[0],
		"mission_bot_drones": [
			{
				"player" : {
					"player_id" : "bot-1",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-1",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
			{
				"player" : {
					"player_id" : "bot-2",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-2",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
			{
				"player" : {
					"player_id" : "bot-3",
					"player_name" : "Grunt",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-2",
					"player_name": "Grunt",
					"hull_module" : DroneData.hulls[0],
					"turret_module": DroneData.turrets[0],
					"weapon_module": DroneData.weapons[0],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
		],
		"unlocked_module": {},
		"unlocked_map": {}
	},
	{
		"mission_id": "chapter-1_mission-5",
		"mission_index": 4,
		"mission_name": "Hey Bob",
		"mission_objective": "Defeat Bob",
		"mission_map": MapData.MAPS[0],
		"mission_bot_drones": [
			{
				"player" : {
					"player_id" : "bot-1",
					"player_name" : "Bob",
					"player_team" : 1,
				},
				"drone_data" : {
					"player_id": "bot-1",
					"player_name": "Bob",
					"hull_module" : {
						"module_id":"h-1",
						"module_name" : "Howen AM-A",
						"scene" : "res://entity/drone_hulls/hull_6/hull_6.tscn",
						"icon" : "res://assets/ui/choose-module/drone/hull_6.png",
						"infos" : [
							"Hp : 420",
							"Speed : 4",
							"Travese : 2"
						],
						"modifier" : {
							"hp" : 420,
							"max_hp" : 420,
							"speed" : 4.0,
							"turning_speed" : 2.0
						}
					},
					"turret_module":{
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
							"turret_hp" : 940,
							"turret_max_hp" : 940,
							"turret_ammo" : 9120,
							"turret_max_ammo" : 9120
						}
					},
					"weapon_module": DroneData.weapons[1],
					"sensor_module": DroneData.sensors[0],
					"color": Color.red
				}
			},
		],
		"unlocked_module": DroneData.weapons[1],
		"unlocked_map": {}
	},
]

export var mission_id :String = ""
export var mission_index :int =  0
export var mission_name :String =  ""
export var mission_objective :String =  ""
export var mission_bot_drones :Array = []
var mission_map :MapData = MapData.new()
var unlocked_module :DroneModuleData = DroneModuleData.new()
var unlocked_map :MapData = MapData.new()

func from_dictionary(data : Dictionary):
	mission_id = data["mission_id"]
	mission_index = data["mission_index"]
	mission_name = data["mission_name"]
	mission_objective = data["mission_objective"]
	mission_bot_drones = data["mission_bot_drones"]
	mission_map = MapData.new()
	mission_map.from_dictionary(data["mission_map"])
	unlocked_module = DroneModuleData.new()
	unlocked_module.from_dictionary(data["unlocked_module"])
	unlocked_map = MapData.new()
	unlocked_map.from_dictionary(data["unlocked_map"])
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["mission_id"] = mission_id
	data["mission_index"] = mission_index
	data["mission_name"] = mission_name
	data["mission_objective"] = mission_objective
	data["mission_bot_drones"] = mission_bot_drones
	data["mission_map"] = mission_map.to_dictionary()
	data["unlocked_module"] = unlocked_module.to_dictionary()
	data["unlocked_map"] = unlocked_map.to_dictionary()
	return data
	
