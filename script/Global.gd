extends Node

func _ready():
	load_player_data()
	load_player_drone_data()
	
################################################################
# player
var player: PlayerData = PlayerData.new()

func load_player_data():
	player.load_data("player.data")
	if player.is_empty():
		player.player_id = GDUUID.v4()
		player.player_name = RandomNameGenerator.generate()
		player.save_data("player.data")
	
################################################################
# player drone
var player_drone_data : DroneData = DroneData.new()

func load_player_drone_data():
	player_drone_data.load_data("player_drone_data.data")
	
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






