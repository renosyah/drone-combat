extends Node

const sound_amplified = 10
const player_data_file = "player.data"
const player_drone_data_file = "player_drone_data.data"

func _ready():
	load_player_data()
	load_player_drone_data()
	
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

static func randomize_drone(player_id, player_name :String ) -> DroneData:
	var data = DroneData.new()
	randomize()
	data.player_id =  player_id
	data.player_name =  player_name
	data.hull_module = DroneModuleData.new().parse_from_dictionary(DroneData.hulls[rand_range(0, DroneData.hulls.size() - 1)])
	data.turret_module = DroneModuleData.new().parse_from_dictionary(DroneData.turrets[rand_range(0, DroneData.turrets.size() - 1)])
	data.weapon_module = DroneModuleData.new().parse_from_dictionary(DroneData.weapons[rand_range(0, DroneData.weapons.size() - 1)])
	data.sensor_module = DroneModuleData.new().parse_from_dictionary(DroneData.sensors[rand_range(0, DroneData.sensors.size() - 1)])
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
	
remotesync func on_host_game_session_ready(_mp_game_data : Dictionary = {}):	
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
var mp_game_data = {}
var mp_exception_message = ""

################################################################






