extends Node
class_name BattleSp

const DAMAGE = 1
const CRITICAL_DAMAGE = 2
const NO_DAMAGE = 3

const MISSION_ONGOING = 1
const MISSION_SUCCESS = 2
const MISSION_FAILED = 3

var _map : BaseMap

export var camera_scene : Resource = preload("res://assets/gameplay-camera/gameplay_camera.tscn")
var _camera : GameplayCamera

export var env_scene : Resource = preload("res://assets/enviroment/WorldEnvironment.tscn")
var _env : WorldEnvironment

export var light_scene : Resource = preload("res://assets/enviroment/DirectionalLight.tscn")
var _light: DirectionalLight

export var ui_scene : Resource = preload("res://gameplay/sp/ui/ui.tscn")
var _ui: Control

var _item_holder :Node

var floating_message_pool = []

func _ready():
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
	_init_floating_message_pool()
	_init_item_holder()
	_load_map()
	_load_camera()
	_load_enviroment()
	_load_light()
	_load_ui()
	
	# prepare ad
	Admob.load_interstitial()
	
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
	var map_data :MapData = Global.sp_game_data.mission_map
	
	var _map_asset = load(map_data.scene).instance()
	add_child(_map_asset)
	_map = _map_asset
	_map.translation.y = -0.5
	_map.connect("on_map_click", self,"on_map_click")
	
func load_map_stuff():
	_map.generate_random_stuff_placement()
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
	_ui.connect("exit_game_session", self, "_on_exit_game_session")
	_ui.connect("on_next_mission_press", self, "_on_next_mission_press")
	_ui.connect("on_restart_mission_press", self ,"_on_restart_mission_press")
	_ui.connect("on_open_credit", self, "_on_open_credit")
	
	_ui.set_camera(_camera)
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	pass
	
func _on_next_mission_press():
	if Global.is_last_mission():
		return
		
	if Admob.get_is_interstitial_loaded():
		Admob.connect("interstitial_failed_to_show", self, "_interstitial_finish")
		Admob.connect("interstitial_closed", self, "_interstitial_finish")
		if Admob.get_is_banner_loaded():
			Admob.hide_banner()
			
		Admob.show_interstitial()
		return
		
	_interstitial_finish()
	
func _interstitial_finish():
	if Admob.get_is_banner_loaded():
		Admob.show_banner()
		
	Global.sp_game_data.from_dictionary(Global.get_next_mission())
	get_tree().change_scene("res://assets/ui/mission_briefing/mission_briefing.tscn")
	
func _on_restart_mission_press():
	get_tree().reload_current_scene()
	
func _on_open_credit():
	Network.disconnect_from_server()
	get_tree().change_scene("res://menu/credit-menu/credit_menu.tscn")
	
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
var _enemy = []
var _all = []

func spawn_bot_drones():
	for data in Global.sp_game_data.mission_bot_drones:
		var spawner = DroneData.new()
		spawner.from_dictionary(data["drone_data"])
		
		var spawn_pos = _map.get_rand_pos()
		spawn_pos.y = 8.0
		
		var player = PlayerData.new()
		player.from_dictionary(data["player"])
		
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
			
		spawned.waypoint_mode = true
		_bots.append(spawned)
	
func spawn_player_drones() -> BaseHull:
	var spawner = DroneData.new()
	spawner.from_dictionary(Global.player_drone_data.to_dictionary())
	spawner.color = Color("#000080")
	
	var spawn_pos = _map.get_rand_pos()
	spawn_pos.y = 8.0
	
	var player = Global.player
	
	var spawned = spawner.spawn(player, self, spawn_pos)
	if spawned is BaseHull:
		spawned.connect("on_respawn", self, "on_drone_respawn")
		spawned.connect("on_dead", self, "on_drone_dead")
		spawned.connect("on_take_damage", self, "on_drone_take_damage")
		spawned.connect("on_heal", self, "on_drone_heal")
		spawned.connect("on_respawn_ready", self,"on_drone_respawn_ready")
		spawned.set_hp_bar(Color.green, false)
		
		var turret = spawned.get_turret()
		turret.connect("on_resupply", self, "on_drone_turret_resupply")
		turret.connect("on_take_damage", self, "on_drone_turret_take_damage")
		turret.connect("on_dead", self, "on_drone_turret_dead")
		turret.connect("on_turret_ammo_update", self, "on_drone_turret_ammo_update")
		
	return spawned
	
func set_minimap_player_objects(local_drone_player : PlayerData):
	for spawned in _all:
		var player_from_drone :PlayerData = spawned.player
		var is_friendly = (player_from_drone.player_team == local_drone_player.player_team)
		if not is_friendly:
			_enemy.append(spawned)
			
		var show_hp_bar = (player_from_drone.player_id != local_drone_player.player_id)
		var hp_bar_color = Color.blue if is_friendly else Color.red
		spawned.set_hp_bar(hp_bar_color, show_hp_bar)
		var marker_icon = preload("res://assets/ui/mini_map/warning.png")
		_ui.add_minimap_object_marker(spawned, marker_icon, hp_bar_color)
		
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
# disposesing
func _on_exit_game_session():
	Network.disconnect_from_server()
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
