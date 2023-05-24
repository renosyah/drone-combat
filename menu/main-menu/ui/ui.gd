extends Control

signal on_drone_data_change()

onready var _choose_misson = $CanvasLayer/choose_mission
onready var _choose_map = $CanvasLayer/choose_map
onready var _host_setting = $CanvasLayer/host_setting
onready var _server_browser = $CanvasLayer/server_browser
onready var _dialog_exit_option = $CanvasLayer/simple_dialog_option

onready var _player_name_label = $CanvasLayer/VBoxContainer/MarginContainer/Control3/HBoxContainer/player_name_label
onready var _input_name_dialog = $CanvasLayer/input_name

onready var _input_color_dialog = $CanvasLayer/input_color
onready var _input_color_btn_color = $CanvasLayer/VBoxContainer/Control2/VBoxContainer/HBoxContainer2/drone_color_btn/ColorRect

onready var _choose_module_dialog = $CanvasLayer/choose_drone_module
onready var _setting = $CanvasLayer/setting

onready var _error_dialog = $CanvasLayer/exception_message

func _ready():
	_choose_misson.visible = false
	_dialog_exit_option.visible = false
	_error_dialog.visible = false
	
	_server_browser.start_finding()
	init_drone_data_setting()
	check_error()
	
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
	
func check_error():
	if Global.mp_exception_message.empty():
		return
		
	_error_dialog.display_message("Error!", Global.mp_exception_message)
	_error_dialog.visible = true
	Global.mp_exception_message = ""
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			_on_back_pressed()
			return
			
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
			_on_back_pressed()
			return
		
	
func init_drone_data_setting():
	_player_name_label.text = Global.player.player_name
	_input_color_btn_color.color = Global.player_drone_data.color
	
	
func _on_battle_pressed():
	_choose_misson.missions = Global.campaign_missions
	_choose_misson.show_missions()
	_choose_misson.visible = true
	
func _on_choose_mission_on_mission_choosed(_mission_data):
	Global.sp_game_data = _mission_data
	Network.connect("server_player_connected", self ,"_server_player_connected")
	var err = Network.create_server(Global.server.max_player, Global.server.port,{"name" : Global.player.player_name})
	if err != OK:
		return
	
func _server_player_connected(_player_network_unique_id : int, _player : Dictionary):
	get_tree().change_scene("res://assets/ui/mission_briefing/mission_briefing.tscn")
	
	
func _on_host_pressed():
	var current_map :MapData = MapData.new()
	current_map.from_dictionary(Global.mp_game_data["map"])
	_choose_map.current_map_id = current_map.map_id
	_choose_map.maps = MapData.MAPS
	_choose_map.show_maps()
	_choose_map.visible = true
	
func _on_choose_map_on_map_choosed(_map_data :Dictionary):
	Global.mp_game_data["map"] = _map_data
	_host_setting.visible = true
	
func _on_host_setting_create():
	Global.mode = Global.MODE_HOST
	get_tree().change_scene("res://menu/lobby-menu/lobby_menu.tscn")
	
func _on_join_pressed():
	_server_browser.visible = true
	
	
func _on_server_browser_on_error(msg):
	print(msg)
	
	
func _on_input_name_on_continue(_player_name, html_color):
	Global.player.player_name = _player_name
	Global.player.save_data(Global.player_data_file)
	_player_name_label.text = Global.player.player_name
	
	
func _on_server_browser_on_join(info):
	Global.mode = Global.MODE_JOIN
	Global.client.ip = info["ip"]
	get_tree().change_scene("res://menu/lobby-menu/lobby_menu.tscn")
	
	
func _on_server_browser_close():
	_server_browser.visible = false
	
	
func _on_back_pressed():
	_dialog_exit_option.display_message("Attention!","Are you sure want exit?")
	_dialog_exit_option.visible = true
	
	
func _on_simple_dialog_option_on_yes():
	get_tree().quit()
	
	
func _on_change_name_pressed():
	_input_name_dialog.visible = true
	
func _on_setting_pressed():
	_setting.visible = true
	
func _on_drone_weapon_btn_pressed():
	_choose_module_dialog.title = "Weapon"
	_choose_module_dialog.current_module_id = Global.player_drone_data.weapon_module.module_id
	_choose_module_dialog.modules = DroneData.weapons
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_weapon_choosed")
	show_module_dialog()
	
	
func _on_module_weapon_choosed(_data :DroneModuleData):
	Global.player_drone_data.weapon_module = _data
	apply_drone_module_update()
	
	
func _on_drone_turret_btn_pressed():
	_choose_module_dialog.title = "Turret"
	_choose_module_dialog.current_module_id = Global.player_drone_data.turret_module.module_id
	_choose_module_dialog.modules = DroneData.turrets
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_turret_choosed")
	show_module_dialog()
	
	
func _on_module_turret_choosed(_data :DroneModuleData):
	Global.player_drone_data.turret_module = _data
	apply_drone_module_update()
	
	
func _on_drone_hull_btn_pressed():
	_choose_module_dialog.title = "Hull"
	_choose_module_dialog.current_module_id = Global.player_drone_data.hull_module.module_id
	_choose_module_dialog.modules = DroneData.hulls
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_hull_choosed")
	show_module_dialog()
	
	
func _on_module_hull_choosed(_data :DroneModuleData):
	Global.player_drone_data.hull_module = _data
	apply_drone_module_update()
	
	
func _on_drone_sensor_btn_pressed():
	_choose_module_dialog.title = "Sensor"
	_choose_module_dialog.current_module_id = Global.player_drone_data.sensor_module.module_id
	_choose_module_dialog.modules = DroneData.sensors
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_sensor_choosed")
	show_module_dialog()
	
	
func _on_module_sensor_choosed(_data :DroneModuleData):
	Global.player_drone_data.sensor_module = _data
	apply_drone_module_update()
	
	
func show_module_dialog():
	_choose_module_dialog.show_modules()
	_choose_module_dialog.visible = true
	
	
func clear_choose_module_dialog_signal():
	for i in _choose_module_dialog.get_signal_connection_list("on_module_choosed"):
		_choose_module_dialog.disconnect("on_module_choosed", self, i.method)
	
	
func apply_drone_module_update():
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	_choose_module_dialog.visible = false
	emit_signal("on_drone_data_change")
	
	
func _on_drone_color_btn_pressed():
	_input_color_dialog.visible = true
	
	
func _on_input_color_on_pick(_color):
	_input_color_btn_color.color = _color
	Global.player_drone_data.color = _color
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	emit_signal("on_drone_data_change")


























































