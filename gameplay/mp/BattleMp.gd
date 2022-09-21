extends Node
class_name BattleMp

const DAMAGE = 1
const CRITICAL_DAMAGE = 2
const NO_DAMAGE = 3

var _map : BaseMap

export var camera_scene : Resource = preload("res://assets/gameplay-camera/gameplay_camera.tscn")
var _camera : GameplayCamera

export var env_scene : Resource = preload("res://assets/enviroment/WorldEnvironment.tscn")
var _env : WorldEnvironment

export var light_scene : Resource = preload("res://assets/enviroment/DirectionalLight.tscn")
var _light: DirectionalLight

export var ui_scene : Resource = preload("res://gameplay/mp/ui/ui.tscn")
var _ui: Control

var _item_holder :Node

var floating_message_pool = []

func _ready():
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
	_init_connection_watcher()
	_init_floating_message_pool()
	_init_item_holder()
	_load_map()
	_load_camera()
	_load_enviroment()
	_load_light()
	_load_ui()
	
################################################################
# network connection watcher
# for both client and host
func _init_connection_watcher():
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
	pass
	
func on_player_disynchronize(_player_name : String):
	pass
	
func on_host_disconnected():
	Global.mp_exception_message = "Unexpected exit by Server!"
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
################################################################
# client pooling request
onready var latency_delay = 0.08
var network_timmer : Timer

func init_client():
	if is_server():
		return
		
	Global.connect("on_host_game_session_ready", self, "_on_host_game_session_ready_rematch")
	
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
	
func _on_host_game_session_ready_rematch(_mp_game_data : Dictionary):
	Global.mp_game_data = _mp_game_data
	get_tree().change_scene("res://gameplay/mp/client/battle.tscn")
	
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
# floating message pool
func _init_floating_message_pool():
	for i in range(25):
		var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
		add_child(msg)
		floating_message_pool.append(msg)
	
func _get_floating_message() -> Spatial:
	for i in floating_message_pool:
		if i.hide == true:
			return i
			
	var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
	add_child(msg)
	floating_message_pool.append(msg)
	return msg
	
################################################################
# map
func _load_map():
	var map_data :MapData = MapData.new()
	map_data.from_dictionary(Global.mp_game_data["map"])
	
	var _map_asset = load(map_data.scene).instance()
	add_child(_map_asset)
	_map = _map_asset
	_map.translation.y = -0.5
	_map.connect("on_map_click", self,"on_map_click")
	
func load_map_stuff():
	if is_server():
		_map.generate_random_stuff_placement()
		_map.spawn_random_stuff_placement()
		Global.mp_game_data["map_stuffs"] = _map.stuffs
		Global.on_host_game_session_ready(Global.mp_game_data)
		
	else:
		_map.stuffs = Global.mp_game_data["map_stuffs"]
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
	_ui.connect("on_spectate_previous", self, "_on_spectate_previous")
	_ui.connect("on_spectate_next", self, "_on_spectate_next")
	_ui.connect("exit_game_session", self, "_on_exit_game_session")
	_ui.connect("on_rematch", self, "_on_rematch")
	
	_ui.set_camera(_camera)
	_ui.set_respawn_time(Global.mp_game_data["respawn_time"])
	_ui.display_rematch(is_server())
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	pass
	
func on_respawn_button_press():
	pass
	
func _on_spectate_previous():
	pass
	
func _on_spectate_next():
	pass
	
func _on_rematch():
	if not is_server():
		return
		
	get_tree().change_scene("res://gameplay/mp/host/battle.tscn")
	
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
var _all = []

func spawn_drones_and_get_drone_owned_by(local_player : PlayerData) -> BaseHull:
	var drone : BaseHull
	
	for data in Global.mp_players:
		var spawner = DroneData.new()
		spawner.from_dictionary(data["drone_data"])
		
		var spawn_pos = _map.get_rand_pos()
		spawn_pos.y = 8.0
		
		var player = PlayerData.new()
		player.from_dictionary(data)
		
		var spawned = spawner.spawn(player, self, spawn_pos)
		if spawned is BaseHull:
			spawned.connect("on_respawn", self, "on_drone_respawn")
			spawned.connect("on_dead", self, "on_drone_dead")
			spawned.connect("on_take_damage", self, "on_drone_take_damage")
			spawned.connect("on_heal", self, "on_drone_heal")
			spawned.connect("on_respawn_ready", self,"on_drone_respawn_ready")
			
			var turret = spawned.get_turret()
			turret.connect("on_resupply", self, "on_drone_turret_resupply")
			turret.connect("on_take_damage", self, "on_drone_turret_take_damage")
			turret.connect("on_dead", self, "on_drone_turret_dead")
			
		if player.player_id == local_player.player_id:
			drone = spawned
			drone.set_hp_bar(Color.green, false)
			drone.get_turret().connect("on_turret_ammo_update", self, "on_drone_turret_ammo_update")
			
		if data.has("is_bot"):
			spawned.waypoint_mode = true
			_bots.append(spawned)
			
		else:
			_players.append(spawned)
			
		_ui.update_scoreboard(player.player_id, 0, 0,spawner.color, player.player_name, player.player_team)
		_all.append(spawned)
		
	return drone
	
func set_minimap_player_objects(local_drone_player : PlayerData):
	for spawned in _all:
		var player_from_drone :PlayerData = spawned.player
		var is_friendly = (player_from_drone.player_team == local_drone_player.player_team)
		var show_hp_bar = (player_from_drone.player_id != local_drone_player.player_id)
		var hp_bar_color = Color.blue if is_friendly else Color.red
		spawned.set_hp_bar(hp_bar_color, show_hp_bar)
		var marker_icon = preload("res://assets/ui/mini_map/warning.png")
		_ui.add_minimap_object_marker(spawned, marker_icon, hp_bar_color)
	
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
# drop item
func _init_item_holder():
	_item_holder = Node.new()
	add_child(_item_holder)

remotesync func spawn_healing_item(at : Vector3):
	if _item_holder.get_child_count() > 5:
		return
		
	var item = preload("res://entity/item/healing_item/healing_item.tscn").instance()
	_item_holder.add_child(item)
	item.heal_hp = int(rand_range(100, 220))
	item.translation = at
	item.translation.y = 5
	
	var marker_icon = preload("res://assets/ui/mini_map/hp.png")
	_ui.add_minimap_object_marker(item, marker_icon, Color.green)
	
remotesync func spawn_ammo_item(at : Vector3):
	if _item_holder.get_child_count() > 5:
		return
		
	var item = preload("res://entity/item/ammo_item/ammo_item.tscn").instance()
	_item_holder.add_child(item)
	item.ammo_added = int(rand_range(200, 300))
	item.translation = at
	item.translation.y = 5
	
	var marker_icon = preload("res://assets/ui/mini_map/ammo.png")
	_ui.add_minimap_object_marker(item, marker_icon, Color.orange)
	
################################################################
# drone event signal handler
func on_drone_respawn(_entity :BaseHull):
	pass
	
func on_drone_respawn_ready(_entity :BaseHull):
	pass
	
func on_drone_turret_ammo_update(_turret :BaseTurret, _ammo_left :int, _max_ammo :int):
	pass
	
func on_drone_turret_resupply(_entity :BaseTurret, _ammo_added :int):
	var msg = _get_floating_message()
	msg.show()
		
	var spread = 2.0
	msg.translation = _entity.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	
	msg.set_color(Color.orange)
	msg.set_message("+" + str(_ammo_added) + " Ammo")
	
	
func on_drone_heal(_entity :BaseEntity, _hp_added :int):
	var msg = _get_floating_message()
	msg.show()
	
	var spread = 2.0
	msg.translation = _entity.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	
	msg.set_color(Color.green)
	msg.set_message("+" + str(_hp_added) + " Hp")
	
	
func on_drone_turret_take_damage(_turret :BaseTurret, _damage :int, _hit_by: PlayerData):
	on_drone_take_damage(_turret, _damage, _hit_by)
	
func on_drone_take_damage(_entity :BaseEntity, _damage :int, _hit_by: PlayerData):
	if randf() > 0.2 and _damage < 10:
		return
		
	var msg = _get_floating_message()
	msg.show()
	
	var spread = 2.0
	msg.translation = _entity.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	
	msg.set_color(Color.red)
	msg.set_message("-" + str(_damage))
	
func on_drone_turret_dead(_turret :BaseTurret, _hit_by: PlayerData):
	var msg = _get_floating_message()
	msg.show()
	
	var spread = 2.0
	msg.translation = _turret.global_transform.origin
	msg.translation.z += rand_range(-spread, spread)
	msg.translation.x += rand_range(-spread, spread)
	msg.translation.y += 2.0 + rand_range(-spread, spread)
	msg.set_color(Color.red)
	msg.set_message("Turret Disabled!")
	
func on_drone_dead(_entity :BaseEntity, _hit_by: PlayerData):
	var msg = _get_floating_message()
	msg.show()
	
	msg.translation = _entity.global_transform.origin
	msg.set_color(Color.red)
	msg.set_message("Drone Destroyed!")
	
################################################################
# game event
remotesync func _update_battle_time(time_left:int):
	update_battle_time(time_left)
	
func update_battle_time(time_left:int):
	pass
	
remotesync func _battle_finish(scores :Array):
	battle_finish(scores)
	
func battle_finish(scores :Array):
	pass
	
################################################################
# disposesing
func _on_exit_game_session():
	for drone in _all:
		drone.queue_free()
		
	queue_free()
	
	Network.disconnect_from_server()
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
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



