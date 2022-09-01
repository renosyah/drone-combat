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
# client pooling request
onready var latency_delay = 0.08
var network_timmer : Timer

func init_client():
	if is_server():
		return
		
	network_timmer = Timer.new()
	network_timmer.wait_time = latency_delay
	network_timmer.connect("timeout", self , "on_client_pool_network_request")
	network_timmer.autostart = true
	add_child(network_timmer)
	
func on_client_pool_network_request():
	# send request every latency
	# to server for commanding
	# client unit
	pass
	
################################################################
# for commanding
remote func _move_drone(_target : NodePath, _input : Vector2):
	var drone = get_node_or_null(_target)
	if not is_instance_valid(drone):
		return
		
	if not drone is BaseHull:
		return
		
	drone.direction = _input
		
################################################################
# map
func _load_map():
	if not map_scene:
		return
		
	var _map_asset = map_scene.instance()
	add_child(_map_asset)
	_map = _map_asset
	_map.translation.y = -0.5
	_map.connect("on_map_click", self,"on_map_click")
	
func load_map_stuff():
	if is_server():
		_map.generate_random_stuff_placement()
		_map.spawn_random_stuff_placement()
		Global.on_host_game_session_ready({"stuffs" : _map.stuffs})
		
	else:
		_map.stuffs = Global.mp_game_data["stuffs"]
		_map.spawn_random_stuff_placement()
	
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
	
################################################################
# ui
func _load_ui():
	if not ui_scene:
		return
		
	var _ui_asset = ui_scene.instance()
	add_child(_ui_asset)
	_ui = _ui_asset
	
	_ui.connect("on_joystick_input", self, "on_joystick_input")
	_ui.connect("on_respawn_button_press", self, "on_respawn_button_press")
	
	_ui.set_camera(_camera)
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	pass
	
func on_respawn_button_press():
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
# drone spawner
var _bots = []
var _players = []

func spawn_drones_and_get_dronw_owned_by(local_player_id : String) -> BaseHull:
	var drones = []
	
	for data in Global.mp_players:
		var d = data["drone_data"].duplicate()
		d["is_bot"] = data.has("is_bot")
		drones.append(d)
		
	var drone : BaseHull
	
	for data in drones:
		var spawner  = DroneData.new()
		spawner.from_dictionary(data)
		
		var spawn_pos = _map.get_rand_pos()
		spawn_pos.y = 8.0
		
		var spawned = spawner.spawn(data["player_id"], self, spawn_pos)
		_ui.add_minimap_object(spawned)
		
		if spawned is BaseEntity:
			spawned.connect("on_ready", self, "on_drone_ready")
			spawned.connect("on_dead", self, "on_drone_dead")
			spawned.connect("on_turret_dead", self, "on_drone_turret_dead")
			spawned.connect("on_take_damage", self, "on_drone_take_damage")
			
		spawned.set_hp_bar(Color.red, true)
			
		if data["player_id"] == local_player_id:
			drone = spawned
			spawned.set_hp_bar(Color.green, false)
			
		if data["is_bot"]:
			spawned.waypoint_mode = true
			_bots.append(spawned)
		else:
			_players.append(spawned)
			
	return drone
	
func respawn_drone(drone : NodePath):
	if is_server():
		_respawn_drone(drone)
	else:
		rpc_id(Network.PLAYER_HOST_ID ,"_respawn_drone", drone)
	
remote func _respawn_drone(drone : NodePath):
	var drone_node = get_node_or_null(drone)
	if not is_instance_valid(drone_node):
		return
		
	if not drone_node is BaseHull:
		return
		
	drone_node.reset()
	
	var respawn_pos = _map.get_rand_pos()
	respawn_pos.y = 8.0
	
	rpc("_reposition_drone",drone, respawn_pos)
	
remotesync func _reposition_drone(drone : NodePath, pos : Vector3):
	var drone_node = get_node_or_null(drone)
	if not is_instance_valid(drone_node):
		return
		
	drone_node.translation = pos
	
################################################################
# drone event signal handler
func on_drone_ready(_entity):
	pass
	
func on_drone_take_damage(_entity, _damage):
	var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
	add_child(msg)
	
	var spread = 2.0
	msg.translation = _entity.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	
	msg.set_color(Color.orange)
	msg.set_message("-" + str(_damage))
	
func on_drone_turret_dead(_turret):
	var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
	add_child(msg)
	
	var spread = 2.0
	msg.translation = _turret.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	msg.set_color(Color.red)
	msg.set_message("Turret Disabled!")
	
func on_drone_dead(_entity):
	var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
	add_child(msg)
	msg.translation = _entity.global_transform.origin
	msg.set_color(Color.red)
	msg.set_message("Drone Destroyed!")
	
################################################################
# utils code
func _create_respawn_time_delay() -> Timer:
	var _respawn_delay_timer = Timer.new()
	_respawn_delay_timer.wait_time = 3
	_respawn_delay_timer.one_shot = true
	_respawn_delay_timer.autostart = false
	add_child(_respawn_delay_timer)
	return _respawn_delay_timer
	
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



