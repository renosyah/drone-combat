extends Node
const DEKSTOP =  ["Server", "Windows", "WinRT", "X11"]

const player_data_file = "player.data"
const player_unlocked_missions_data_file = "player_unlocked_missions.data"
const player_unlocked_modules_data_file = "player_unlocked_modules.data"
const player_unlocked_maps_data_file = "player_unlocked_maps.data"
const player_drone_data_file = "player_drone_data.data"

onready var sound_amplified = 10 if not OS.get_name() in Global.DEKSTOP else 5

func _ready():
	load_player_unlocked_missions()
	init_player_unlocked_missions()
	
	load_player_unlocked_modules()
	init_player_starting_unlocked_modules()
	
	load_player_unlocked_maps()
	init_player_starting_unlocked_maps()
	
	load_player_data()
	load_player_drone_data()
	
################################################################
# player progress modules
var player_unlocked_modules : Array = []

func load_player_unlocked_modules():
	var is_exist = SaveLoad.load_save(player_unlocked_modules_data_file) != null
	if not is_exist:
		return
	
	player_unlocked_modules = SaveLoad.load_save(player_unlocked_modules_data_file)
	
func update_player_unlocked_modules(module_id : String):
	var is_exist = SaveLoad.load_save(player_unlocked_modules_data_file) != null
	if not is_exist:
		return
		
	if module_id in player_unlocked_modules:
		return
	
	player_unlocked_modules.append(module_id)
	SaveLoad.save(player_unlocked_modules_data_file, player_unlocked_modules)
	player_unlocked_modules = SaveLoad.load_save(player_unlocked_modules_data_file)
	
	
func init_player_starting_unlocked_modules():
	var is_exist = SaveLoad.load_save(player_unlocked_modules_data_file) != null
	if is_exist:
		return
	
	player_unlocked_modules = ["w-1", "t-1", "h-1", "s-1"]
	SaveLoad.save(player_unlocked_modules_data_file, player_unlocked_modules)
	
################################################################
# player progress modules
var player_unlocked_maps : Array = []

func load_player_unlocked_maps():
	var is_exist = SaveLoad.load_save(player_unlocked_maps_data_file) != null
	if not is_exist:
		return
	
	player_unlocked_maps = SaveLoad.load_save(player_unlocked_maps_data_file)
	
func update_player_unlocked_maps(map_id : String):
	var is_exist = SaveLoad.load_save(player_unlocked_maps_data_file) != null
	if not is_exist:
		return
		
	if map_id in player_unlocked_maps:
		return
	
	player_unlocked_maps.append(map_id)
	SaveLoad.save(player_unlocked_maps_data_file, player_unlocked_maps)
	player_unlocked_maps = SaveLoad.load_save(player_unlocked_maps_data_file)
	
	
func init_player_starting_unlocked_maps():
	var is_exist = SaveLoad.load_save(player_unlocked_maps_data_file) != null
	if is_exist:
		return
	
	player_unlocked_maps = ["m-1"]
	SaveLoad.save(player_unlocked_maps_data_file, player_unlocked_maps)
	
################################################################
# player progress misson
var player_unlocked_missions : Array = []

func load_player_unlocked_missions():
	var is_exist = SaveLoad.load_save(player_unlocked_missions_data_file) != null
	if not is_exist:
		return
	
	player_unlocked_missions = SaveLoad.load_save(player_unlocked_missions_data_file)
	
func update_player_unlocked_missions(mission_id : String):
	var is_exist = SaveLoad.load_save(player_unlocked_missions_data_file) != null
	if not is_exist:
		return
		
	if mission_id in player_unlocked_missions:
		return
	
	player_unlocked_missions.append(mission_id)
	SaveLoad.save(player_unlocked_missions_data_file, player_unlocked_missions)
	player_unlocked_missions = SaveLoad.load_save(player_unlocked_missions_data_file)
	
	
func init_player_unlocked_missions():
	var is_exist = SaveLoad.load_save(player_unlocked_missions_data_file) != null
	if is_exist:
		return
	
	player_unlocked_missions = ["chapter-1_mission-1"]
	SaveLoad.save(player_unlocked_missions_data_file, player_unlocked_missions)
	
################################################################
# player
var player: PlayerData = PlayerData.new()

func load_player_data():
	player.load_data(player_data_file)
	if player.is_empty():
		player.player_id = GDUUID.v4()
		player.player_name = RandomNameGenerator.generate()
		player.save_data(player_data_file)
	
################################################################
# player drone
var player_drone_data : DroneData = DroneData.new()

func randomize_drone(player_id, player_name :String ) -> DroneData:
	randomize()
	
	var hulls = []
	for i in DroneData.hulls:
		if i["module_id"] in player_unlocked_modules:
			hulls.append(i)
			
	hulls.shuffle()
	
	var turrets = []
	for i in DroneData.turrets:
		if i["module_id"] in player_unlocked_modules:
			turrets.append(i)
			
	turrets.shuffle()
	
	var weapons = []
	for i in DroneData.weapons:
		if i["module_id"] in player_unlocked_modules:
			weapons.append(i)
			
	weapons.shuffle()
	
	var sensors = []
	for i in DroneData.sensors:
		if i["module_id"] in player_unlocked_modules:
			sensors.append(i)
			
	sensors.shuffle()
	
	var data = DroneData.new()
	randomize()
	data.player_id =  player_id
	data.player_name =  player_name
	data.hull_module = DroneModuleData.new().parse_from_dictionary(hulls[rand_range(0, hulls.size())])
	data.turret_module = DroneModuleData.new().parse_from_dictionary(turrets[rand_range(0, turrets.size())])
	data.weapon_module = DroneModuleData.new().parse_from_dictionary(weapons[rand_range(0, weapons.size())])
	data.sensor_module = DroneModuleData.new().parse_from_dictionary(sensors[rand_range(0, sensors.size())])
	data.color = Color(randf(), randf(), randf(), 1.0)
	return data
	
	
func load_player_drone_data():
	player_drone_data.load_data(player_drone_data_file)
	player_drone_data.player_id = player.player_id
	player_drone_data.player_name = player.player_name
	
################################################################
# sound
var is_sfx_mute :bool = false setget _set_is_sfx_mute

func _set_is_sfx_mute(val:bool):
	is_sfx_mute = val
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), is_sfx_mute)
	
################################################################
# multiplayer connection and data
signal on_host_game_session_ready(_mp_game_data)
	
remotesync func _on_host_game_session_ready(_mp_game_data : Dictionary):
	emit_signal("on_host_game_session_ready", _mp_game_data)
	
func on_host_game_session_ready(_mp_game_data : Dictionary = {}):
	rpc("_on_host_game_session_ready", _mp_game_data)
	
const MODE_HOST = 0
const MODE_JOIN = 1
var mode = MODE_HOST

var server = {
	ip = '127.0.0.1',
	port = 31400,
	max_player = 4,
}
var client = {
	ip = '',
	port = 31400,
	network_unique_id = 0,
}

var mp_players = []
var mp_game_data = {
	"battle_time" : 300,
	"respawn_time": 15,
	"map" : MapData.MAPS[0],
	"map_stuffs":[]

}
var mp_exception_message = ""

const PLAYER_STATUS_NOT_READY = "NOT_READY"
const PLAYER_STATUS_READY = "READY"

func create_mp_player() -> Dictionary:
	var drone = player_drone_data
	return {
		"number" : 0,
		"player_id" : player.player_id,
		"player_name" : player.player_name,
		"player_team" : 0,
		"status" : "Not Ready",
		"flag" : PLAYER_STATUS_NOT_READY,
		"drone_data" : drone.to_dictionary(),
		"color" : drone.color,
	}
	
func create_bot_player() -> Dictionary:
	var bot_id = "BOT-" + str(GDUUID.v4())
	var bot_name = RandomNameGenerator.generate() + " (Bot)"
	var drone = randomize_drone(bot_id, bot_name)
	
	return {
		"number" : 0,
		"player_id" : bot_id,
		"player_name" : bot_name,
		"player_team" : 0,
		"status" : "Ready",
		"is_bot" : true,
		"flag" : PLAYER_STATUS_READY,
		"drone_data" : drone.to_dictionary(),
		"color" : drone.color,
	}
	
################################################################
# singleplayer and data
var sp_game_data :SpMissionData = SpMissionData.new()





