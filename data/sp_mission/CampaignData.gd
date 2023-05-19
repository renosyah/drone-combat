extends Node
class_name CampaignData

const chapter_1_id = "chapter-1_mission-"
const chapter_1_mission_name = [
	"Warm Up",
	"Friend In Need",
	"Ambush",
	"Retake",
	"Oh, Hey Bob!",
	"Regroup",
	"Search And Rescue",
	"Bring It On!",
	"Heat Of Jungle",
	"Lone Wolf",
	"He, Hey Mark",
	"With Or Without",
	"Clear Area",
	"Shockwave Here",
	"No Mercy",
	"Extraction"
]
const chapter_1_mission_objective = [
	"Defeat Enemy Drone",
	"Assist Heikel",
	"Assist Heikel And Cobra",
	"Defeat All Drone",
	"Defeat Bob",
	"Defeat All 4 Drone And Join Heikel",
	"Defeat All 4 Drone And Save Cobra",
	"Assist Cobra",
	"Assist Heikel",
	"Defeat All 4 Drone",
	"Defeat Mark",
	"Assist Heikel And Cobra",
	"Defeat All 6 Drone",
	"Defeat Shockwave",
	"Defeat All 6 Drone",
	"Assist Heikel And Cobra",
]
const chapter_1_mission_reward_module = [
	{},
	DroneData.turrets[1],
	{},{},
	DroneData.weapons[1],
	{},{},{},{},{},
	DroneData.hulls[1],
	{},{},
	DroneData.sensors[1],
	{},{},
]
var chapter_1_mission_bot_drone = [
	[grunt_drone()],
	[grunt_drone(),grunt_drone(), ally_heikel()],
	[grunt_drone(),grunt_drone(), ally_heikel(), ally_cobra()],
	[grunt_drone(),grunt_drone()],
	[boss_bob()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), ally_heikel()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), ally_cobra()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), ally_cobra()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), ally_heikel()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone()],
	[boss_mark()],
	[sergeant_grunt_drone(),sergeant_grunt_drone(), ally_heikel(), ally_cobra()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), sergeant_grunt_drone(), sergeant_grunt_drone()],
	[boss_shockwave()],
	[grunt_drone(),grunt_drone(), grunt_drone(),grunt_drone(), sergeant_grunt_drone(), sergeant_grunt_drone()],
	[grunt_drone(), grunt_drone(),grunt_drone(),grunt_drone(),sergeant_grunt_drone(), sergeant_grunt_drone(),ally_heikel(), ally_cobra()],
]

const chapter_2_id = "chapter-2_mission-"
const chapter_2_mission_name = [
	"Dirt And Wind",
	"Bandits",
	"Wheel VS Track",
	"Back On Track",
	"Agains Odds",
	"Wash Up!",
	"Damn You, Krugger",
	"Smoke And Fire",
	"Noise Of Wind",
	"Dirt In My Engine",
	"Must Do It",
	"Old Friend",
	"The Rattling Snake",
	"Spending Time",
	"Separate",
	"Behind Rock"
]
const chapter_2_mission_objective = [
	"Defeat Your Pursuer",
	"Defeat A Bandit Drone",
	"Defeat All Wheel Drones",
	"Assist Sand And Defeat All Enemy",
	"Defeat All 4 Wheel Drones",
	"Assist Sand",
	"Defeat Krugger",
	"Defeat A Marauder Drone",
	"Defeat All 2 Marauder Drones",
	"Assist Sand",
	"Defeat 2 Grunt And 2 Wheel Drones",
	"Assist Sand And Heikel",
	"Defeat Snake",
	"Defeat All 4 Marauder Drones",
	"Defeat All 6 Wheel Drones",
	"Defeat A Rectketa Guard"
]
const chapter_2_mission_reward_module = [
	{},{},
	DroneData.hulls[2],
	{},
	DroneData.sensors[2],
	{},
	DroneData.weapons[2],
	DroneData.hulls[3],
	{},{},{},
	DroneData.turrets[2],
	DroneData.weapons[3],
	{},{},
	DroneData.hulls[4],
]
var chapter_2_mission_bot_drone = [
	[grunt_drone(), grunt_drone()],
	[wheel_drone()],
	[wheel_drone(), wheel_drone(), wheel_drone()],
	[wheel_drone(), wheel_drone(), grunt_drone(), grunt_drone(), ally_sand()],
	[wheel_drone(), wheel_drone(), wheel_drone(), wheel_drone()],
	[wheel_drone(), wheel_drone(), marauder_drone(), marauder_drone(), ally_sand()],
	[boss_krugger()],
	[marauder_drone()],
	[marauder_drone(), marauder_drone()],
	[marauder_drone(), marauder_drone(), marauder_drone(), marauder_drone(), ally_sand()],
	[wheel_drone(), wheel_drone(), grunt_drone(), grunt_drone()],
	[marauder_drone(), marauder_drone(), marauder_drone(), marauder_drone(), ally_sand(), ally_heikel()],
	[boss_snake()],
	[marauder_drone(), marauder_drone(), marauder_drone(), marauder_drone()],
	[wheel_drone(), wheel_drone(), wheel_drone(), wheel_drone(), wheel_drone()],
	[recketa_guard_drone()]
]



const chapter_3_id = "chapter-3_mission-"
const chapter_3_mission_name = [
	"Blizzard",
	"Snow And Oil",
	"Tick Steel",
	"Juggernaut",
	"Avalance",
	"Lose Direction",
	"Risen Up",
	"Preparing For Worse",
	"Colonel Baton",
	"Run And Hide",
	"Take By Force",
	"Let Them Taste",
	"Major Kura",
	"What, This Again!?",
	"General Kelpin",
	"Final End"
]
const chapter_3_mission_objective = [
	"Regroup With Zilo",
	"Defeat 2 Rectketa Guard",
	"Defeat Rectketa Elite",
	"Assist Juggernaut",
	"Defeat All Enemy",
	"Assist Jugernaut And Zilo",
	"Defeat 4 Rectketa Guard",
	"Defeat 2 Rectketa Guard And 2 Rectketa Elite",
	"Defeat Colonel Baton",
	"Defeat 2 Rectketa Elite",
	"Defeat Rectketa Elite And 2 Rectketa Guard",
	"Defeat All 3 Rectketa Guard",
	"Defeat Major Kura",
	"Defeat All Enemy Drone",
	"Defeat General Kelpin",
	"Defeat All Rectketa Guard And Escape"
]
const chapter_3_mission_reward_module = [
	DroneData.turrets[3],
	{},
	DroneData.hulls[5],
	DroneData.sensors[3],
	{},
	DroneData.turrets[4],
	{},{},
	DroneData.weapons[4],
	{},
	DroneData.turrets[5],
	{},
	DroneData.turrets[6],
	{},
	DroneData.weapons[5],
	{},
]
var chapter_3_mission_bot_drone = [
	[recketa_guard_drone(), ally_zilo()],
	[recketa_guard_drone(), recketa_guard_drone()],
	[recketa_elite_drone()],
	[recketa_guard_drone(), recketa_elite_drone(), ally_juggernaut()],
	[recketa_guard_drone(), recketa_guard_drone()],
	[recketa_guard_drone(), recketa_guard_drone(), recketa_elite_drone(), recketa_elite_drone(), ally_zilo(), ally_juggernaut()],
	[recketa_guard_drone(), recketa_guard_drone(), recketa_guard_drone(), recketa_guard_drone()],
	[recketa_guard_drone(), recketa_guard_drone(), recketa_elite_drone(), recketa_elite_drone()],
	[boss_colonel_baton()],
	[recketa_elite_drone(), recketa_elite_drone()],
	[recketa_guard_drone(), recketa_elite_drone(), recketa_guard_drone()],
	[recketa_guard_drone(), recketa_guard_drone(), recketa_guard_drone()],
	[boss_mayor_kura()],
	[recketa_guard_drone(), recketa_guard_drone(), sergeant_grunt_drone(), sergeant_grunt_drone(), marauder_drone(), marauder_drone()],
	[boss_general_kelpin()],
	[recketa_guard_drone(), recketa_guard_drone(), recketa_guard_drone(), recketa_guard_drone()]
]


func ally_cobra() -> Dictionary:
	return {
		"player" : {
			"player_id" : "bot-cobra",
			"player_name" : "Cobra",
			"player_team" : 0,
		},
		"drone_data" : {
			"player_id": "bot-cobra",
			"player_name": "Cobra",
			"hull_module" : DroneData.hulls[0],
			"turret_module": DroneData.turrets[1],
			"weapon_module": DroneData.weapons[0],
			"sensor_module": DroneData.sensors[0],
			"color": Color("#000080")
		}
	}
	
func ally_heikel() -> Dictionary:
	return {
		"player" : {
			"player_id" : "bot-heikel",
			"player_name" : "Heikel",
			"player_team" : 0,
		},
		"drone_data" : {
			"player_id": "bot-heikel",
			"player_name": "Heikel",
			"hull_module" : DroneData.hulls[0],
			"turret_module": DroneData.turrets[0],
			"weapon_module": DroneData.weapons[0],
			"sensor_module": DroneData.sensors[0],
			"color": Color("#000080")
		}
	}
	
func ally_sand() -> Dictionary:
	return {
		"player" : {
			"player_id" : "bot-sand",
			"player_name" : "Sand",
			"player_team" : 0,
		},
		"drone_data" : {
			"player_id": "bot-sand",
			"player_name": "Sand",
			"hull_module" : DroneData.hulls[1],
			"turret_module": DroneData.turrets[1],
			"weapon_module": DroneData.weapons[1],
			"sensor_module": DroneData.sensors[1],
			"color": Color("#000080")
		}
	}
	
func ally_zilo() -> Dictionary:
	return {
		"player" : {
			"player_id" : "bot-zilo",
			"player_name" : "Zilo",
			"player_team" : 0,
		},
		"drone_data" : {
			"player_id": "bot-zilo",
			"player_name": "Zilo",
			"hull_module" : DroneData.hulls[1],
			"turret_module": DroneData.turrets[4],
			"weapon_module": DroneData.weapons[2],
			"sensor_module": DroneData.sensors[1],
			"color": Color("#000080")
		}
	}
	
func ally_juggernaut() -> Dictionary:
	return {
		"player" : {
			"player_id" : "bot-juggernaut",
			"player_name" : "Juggernaut",
			"player_team" : 0,
		},
		"drone_data" : {
			"player_id": "bot-juggernaut",
			"player_name": "Juggernaut",
			"hull_module" : DroneData.hulls[4],
			"turret_module": DroneData.turrets[5],
			"weapon_module": DroneData.weapons[4],
			"sensor_module": DroneData.sensors[3],
			"color": Color("#000080")
		}
	}
	
	
	
func boss_bob() -> Dictionary:
	return {
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
}

func boss_mark() -> Dictionary:
	return {
	"player" : {
		"player_id" : "bot-1",
		"player_name" : "Mark",
		"player_team" : 1,
	},
	"drone_data" : {
		"player_id": "bot-1",
		"player_name": "Mark",
		"hull_module" : {
			"module_id":"h-2",
			"module_name" : "Howen AM-B",
			"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_3.png",
			"infos" : [
				"Hp : 220",
				"Speed : 3",
				"Travese : 2"
			],
			"modifier" : {
				"hp" : 620,
				"max_hp" : 620,
				"speed" : 3.0,
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
}
	
func boss_shockwave() -> Dictionary:
	return {
	"player" : {
		"player_id" : "bot-1",
		"player_name" : "Shockwave",
		"player_team" : 1,
	},
	"drone_data" : {
		"player_id": "bot-1",
		"player_name": "Shockwave",
		"hull_module" : {
			"module_id":"h-2",
			"module_name" : "Howen AM-B",
			"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_3.png",
			"infos" : [
				"Hp : 220",
				"Speed : 3",
				"Travese : 2"
			],
			"modifier" : {
				"hp" : 620,
				"max_hp" : 620,
				"speed" : 3.0,
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
		"sensor_module": DroneData.sensors[1],
		"color": Color.red
	}
}
func boss_krugger() -> Dictionary:
	return {
	"player" : {
		"player_id" : "bot-1",
		"player_name" : "Krugger",
		"player_team" : 2,
	},
	"drone_data" : {
		"player_id": "bot-1",
		"player_name": "Krugger",
		"hull_module" : {
			"module_id":"h-2",
			"module_name" : "Howen AM-B",
			"scene" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_3.png",
			"infos" : [
				"Hp : 220",
				"Speed : 3",
				"Travese : 2"
			],
			"modifier" : {
				"hp" : 680,
				"max_hp" : 680,
				"speed" : 3.0,
				"turning_speed" : 2.0
			}
		},
		"turret_module":{
			"module_id":"t-3",
			"module_name" : "A-12 Homogen",
			"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/turret_3.png",
			"infos" : [
				"Hp : 890",
				"Rotation : 890",
				"Ammo Capacity : 200"
			],
			"modifier" : {
				"turret_rotation_speed" : 90,
				"turret_hp" : 890,
				"turret_max_hp" : 890,
				"turret_ammo" : 1200,
				"turret_max_ammo" : 1200
			}
		},
		"weapon_module": DroneData.weapons[2],
		"sensor_module": DroneData.sensors[1],
		"color": Color.orange
	}
}
func boss_snake() -> Dictionary:
	return {
	"player" : {
		"player_id" : "bot-1",
		"player_name" : "Snake",
		"player_team" : 2,
	},
	"drone_data" : {
		"player_id": "bot-1",
		"player_name": "Snake",
		"hull_module" : {
			"module_id":"h-3",
			"module_name" : "Izui MK 2",
			"scene" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_2.png",
			"infos" : [
				"Hp : 80",
				"Speed : 5",
				"Travese : 3"
			],
			"modifier" : {
				"hp" : 380,
				"max_hp" : 380,
				"speed" : 5.0,
				"turning_speed" : 3.0
			}
		},
		"turret_module":{
			"module_id":"t-3",
			"module_name" : "A-12 Homogen",
			"scene" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/turret_3.png",
			"infos" : [
				"Hp : 890",
				"Rotation : 890",
				"Ammo Capacity : 200"
			],
			"modifier" : {
				"turret_rotation_speed" : 90,
				"turret_hp" : 890,
				"turret_max_hp" : 890,
				"turret_ammo" : 1200,
				"turret_max_ammo" : 1200
			}
		},
		"weapon_module": DroneData.weapons[3],
		"sensor_module": DroneData.sensors[2],
		"color": Color.orange
	}
}

func boss_colonel_baton() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Col. Baton",
			"player_team" : 3,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Col. Baton",
			"hull_module" : {
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
					"hp" : 820,
					"max_hp" : 820,
					"speed" : 2.0,
					"turning_speed" : 3.0
				}
			},
			"turret_module": {
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
					"turret_hp" : 940,
					"turret_max_hp" : 940,
					"turret_ammo" : 9500,
					"turret_max_ammo" : 9500
				}
			},
			"weapon_module": DroneData.weapons[4],
			"sensor_module": DroneData.sensors[1],
			"color": Color.black
		}
	}

func boss_mayor_kura() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Maj. Kura",
			"player_team" : 3,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Maj. Kura",
			"hull_module" : {
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
					"hp" : 860,
					"max_hp" : 860,
					"speed" : 2.0,
					"turning_speed" : 3.0
				}
			},
			"turret_module":{
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
					"turret_hp" : 960,
					"turret_max_hp" : 960,
					"turret_ammo" : 9500,
					"turret_max_ammo" : 9500
				}
			},
			"weapon_module": DroneData.weapons[4],
			"sensor_module": DroneData.sensors[3],
			"color": Color.black
		}
	}

func boss_general_kelpin() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Gen. Kelpin",
			"player_team" : 3,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Gen. Kelpin",
			"hull_module" : {
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
					"hp" : 1240,
					"max_hp" : 1240,
					"speed" : 2.0,
					"turning_speed" : 2.0
				}
			},
			"turret_module":{
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
					"turret_hp" : 960,
					"turret_max_hp" : 960,
					"turret_ammo" : 9500,
					"turret_max_ammo" : 9500
				}
			},
			"weapon_module": DroneData.weapons[4],
			"sensor_module": DroneData.sensors[3],
			"color": Color.black
		}
	}
func grunt_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Grunt",
			"player_team" : 1,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Grunt",
			"hull_module" : DroneData.hulls[0],
			"turret_module": DroneData.turrets[0],
			"weapon_module": DroneData.weapons[0],
			"sensor_module": DroneData.sensors[0],
			"color": Color.red
		}
	}
	
func sergeant_grunt_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Sgt. Grunt",
			"player_team" : 1,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Sgt. Grunt",
			"hull_module" : DroneData.hulls[0],
			"turret_module": DroneData.turrets[1],
			"weapon_module": DroneData.weapons[1],
			"sensor_module": DroneData.sensors[0],
			"color": Color.red
		}
	}
	
func wheel_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Bandit",
			"player_team" : 2,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Bandit",
			"hull_module" : DroneData.hulls[2],
			"turret_module": DroneData.turrets[0],
			"weapon_module": DroneData.weapons[0],
			"sensor_module": DroneData.sensors[0],
			"color": Color.orange
		}
	}
	
func marauder_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Marauder",
			"player_team" : 2,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Marauder",
			"hull_module" : DroneData.hulls[3],
			"turret_module": DroneData.turrets[1],
			"weapon_module": DroneData.weapons[2],
			"sensor_module": DroneData.sensors[0],
			"color": Color.orange
		}
	}

func recketa_guard_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Guard",
			"player_team" : 3,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Guard",
			"hull_module" : DroneData.hulls[4],
			"turret_module": DroneData.turrets[3],
			"weapon_module": DroneData.weapons[2],
			"sensor_module": DroneData.sensors[1],
			"color": Color.black
		}
	}

func recketa_elite_drone() -> Dictionary:
	var id = GDUUID.v4()
	return {
		"player" : {
			"player_id" : id,
			"player_name" : "Elite",
			"player_team" : 3,
		},
		"drone_data" : {
			"player_id": id,
			"player_name": "Elite",
			"hull_module" : DroneData.hulls[5],
			"turret_module": DroneData.turrets[5],
			"weapon_module": DroneData.weapons[2],
			"sensor_module": DroneData.sensors[3],
			"color": Color.black
		}
	}




