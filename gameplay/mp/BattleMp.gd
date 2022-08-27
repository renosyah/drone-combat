extends Node
class_name BattleMp

export var map_scene : Resource
var _map : BaseMap

export var camera_scene : Resource
var _camera : GameplayCamera

export var env_scene : Resource
var _env : WorldEnvironment

export var light_scene : Resource
var _light: DirectionalLight

export var ui_scene : Resource
var _ui: Control

func _ready():
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
	_load_map()
	_load_camera()
	_load_enviroment()
	_load_light()
	_load_ui()
	
################################################################
# network connection watcher
# for both client and host
func init_connection_watcher():
	Network.connect("server_disconnected", self , "_server_disconnected")
	Network.connect("connection_closed", self , "_connection_closed")
	
	# if some player decide or happen to be disconect
	Network.connect("player_disconnected", self, "_on_player_disconnected")
	Network.connect("receive_player_info", self,"_on_receive_player_info")
	
func _on_player_disconnected(_player_network_unique_id : int):
	Network.request_player_info(_player_network_unique_id)
	
func _on_receive_player_info(_player_network_unique_id : int, data : Dictionary):
	on_player_disynchronize(data["name"])
	
func _server_disconnected():
	on_host_disconnected()
	
func _connection_closed():
	print("exit by Client!")
	
func on_player_disynchronize(_player_name : String):
	pass
	
func on_host_disconnected():
	pass
	
################################################################
# map
func _load_map():
	if not map_scene:
		return
		
	var _map_asset = map_scene.instance()
	add_child(_map_asset)
	_map = _map_asset
	_map.translation.y = -0.8
	_map.connect("on_map_click", self,"on_map_click")
	
func on_map_click(_pos : Vector3):
	pass
	
################################################################
# camera
func _load_camera():
	if not camera_scene:
		return
		
	var _camera_asset = camera_scene.instance()
	add_child(_camera_asset)
	_camera = _camera_asset
	_camera.translation.y = 5
	
################################################################
# ui
func _load_ui():
	if not ui_scene:
		return
		
	var _ui_asset = ui_scene.instance()
	add_child(_ui_asset)
	_ui = _ui_asset
	_ui.connect("on_joystick_input", self, "on_joystick_input")
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	pass
	
################################################################
# env
func _load_enviroment():
	if not env_scene:
		return
		
	var _env_asset = env_scene.instance()
	add_child(_env_asset)
	_env = _env_asset
	
################################################################
# ligth
func _load_light():
	if not light_scene:
		return
		
	var _light_asset = light_scene.instance()
	add_child(_light_asset)
	_light = _light_asset
	
################################################################
# network utils code
func is_server():
	if not is_network_on():
		return false
		
	if not get_tree().is_network_server():
		return false
		
	return true
	
func is_network_on() -> bool:
	if not get_tree().network_peer:
		return false
		
	if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		return false
		
	return true
	
################################################################



