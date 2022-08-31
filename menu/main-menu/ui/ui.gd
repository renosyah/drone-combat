extends Control

signal on_drone_data_change()

onready var _server_browser = $CanvasLayer/server_browser
onready var _dialog_exit_option = $CanvasLayer/simple_dialog_option

onready var _player_name_label = $CanvasLayer/VBoxContainer/Control3/HBoxContainer/player_name_label
onready var _input_name_dialog = $CanvasLayer/input_name

onready var _sfx_sound_setting_icon = $CanvasLayer/VBoxContainer/Control3/HBoxContainer/sfx_setting/TextureRect

onready var _input_color_dialog = $CanvasLayer/input_color
onready var _input_color_btn_color = $CanvasLayer/VBoxContainer/Control2/VBoxContainer/HBoxContainer2/drone_color_btn/ColorRect

onready var _choose_module_dialog = $CanvasLayer/choose_drone_module

func _ready():
	_dialog_exit_option.visible = false
	
	_server_browser.start_finding()
	init_drone_data_setting()
	
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_on.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_off.png")
	
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
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
	Network.connect("server_player_connected", self ,"_server_player_connected")
	var err = Network.create_server(Global.server.max_player, Global.server.port,{"name" : Global.player.player_name})
	if err != OK:
		return
		
func _server_player_connected(_player_network_unique_id : int, _player : Dictionary):
	var player = {
		"player_id" : Global.player.player_id,
		"player_name" : Global.player.player_name,
		"order" : 0,
		"status" : "Ready",
		"flag" : "READY",
		"drone_data" : Global.player_drone_data.to_dictionary()
	}
	Global.mp_players = [player]
	
	for i in range(4):
		var bot_id = "BOT-" + str(GDUUID.v4())
		var bot_name = RandomNameGenerator.generate() + " (Bot)"
		var bot = {
			"player_id" : bot_id,
			"player_name" : bot_name,
			"order" : 0,
			"is_bot" : true,
			"status" : "Ready",
			"flag" : "READY",
			"drone_data" : Global.randomize_drone(bot_id, bot_name).to_dictionary()
		}
		Global.mp_players.append(bot)
		
	get_tree().change_scene("res://gameplay/mp/host/battle.tscn")
	
func _on_host_pressed():
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

func _on_sfx_setting_pressed():
	Global.is_sfx_mute = not Global.is_sfx_mute
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_on.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_off.png")
	
func _on_drone_weapon_btn_pressed():
	_choose_module_dialog.modules = [
		{
			"data" : "res://entity/weapons/mg/mg.tscn",
			"icon" : "res://assets/ui/choose-module/drone/weapon_1.png"
		},
		{
			"data" : "res://entity/weapons/auto_cannon/auto_cannon.tscn",
			"icon" : "res://assets/ui/choose-module/drone/weapon_2.png"
		},
		{
			"data" : "res://entity/weapons/cannon/cannon.tscn",
			"icon" : "res://assets/ui/choose-module/drone/weapon_3.png"
		}
	]
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_weapon_choosed")
	_choose_module_dialog.title = "Weapon"
	_choose_module_dialog.show_modules()
	_choose_module_dialog.visible = true
	
func _on_module_weapon_choosed(_schene : String):
	Global.player_drone_data.weapon_scene = _schene
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	_choose_module_dialog.visible = false
	emit_signal("on_drone_data_change")
	
	
func _on_drone_turret_btn_pressed():
	_choose_module_dialog.modules = [
		{
			"data" : "res://entity/drone_turrets/turret_1/turret_1.tscn",
			"icon" : "res://assets/ui/choose-module/drone/turret_1.png"
		},
		{
			"data" : "res://entity/drone_turrets/turret_2/turret_2.tscn",
			"icon" : "res://assets/ui/choose-module/drone/turret_2.png"
		},
		{
			"data" : "res://entity/drone_turrets/turret_3/turret_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/turret_3.png"
		}
	]
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_turret_choosed")
	_choose_module_dialog.title = "Turret"
	_choose_module_dialog.show_modules()
	_choose_module_dialog.visible = true
	
func _on_module_turret_choosed(_schene : String):
	Global.player_drone_data.turret_scene = _schene
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	_choose_module_dialog.visible = false
	emit_signal("on_drone_data_change")
	
	
func _on_drone_hull_btn_pressed():
	_choose_module_dialog.modules = [
		{
			"data" : "res://entity/drone_hulls/hull_1/hull_1.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_1.png"
		},
		{
			"data" : "res://entity/drone_hulls/hull_2/hull_2.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_2.png"
		},
		{
			"data" : "res://entity/drone_hulls/hull_3/hull_3.tscn",
			"icon" : "res://assets/ui/choose-module/drone/hull_3.png"
		}
	]
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_hull_choosed")
	_choose_module_dialog.title = "Hull"
	_choose_module_dialog.show_modules()
	_choose_module_dialog.visible = true
	
	
func _on_module_hull_choosed(_schene : String):
	Global.player_drone_data.hull_scene = _schene
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	_choose_module_dialog.visible = false
	emit_signal("on_drone_data_change")
	
	
func _on_drone_sensor_btn_pressed():
	_choose_module_dialog.modules = [
		{
			"data" : "res://entity/sensor/sensor_1/sensor_1.tscn",
			"icon" : "res://assets/ui/choose-module/drone/sensor_1.png"
		},
	]
	clear_choose_module_dialog_signal()
	_choose_module_dialog.connect("on_module_choosed", self, "_on_module_sensor_choosed")
	_choose_module_dialog.title = "Sensor"
	_choose_module_dialog.show_modules()
	_choose_module_dialog.visible = true
	
func _on_module_sensor_choosed(_schene : String):
	Global.player_drone_data.sensor_scene = _schene
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	_choose_module_dialog.visible = false
	emit_signal("on_drone_data_change")
	
	
func clear_choose_module_dialog_signal():
	for i in _choose_module_dialog.get_signal_connection_list("on_module_choosed"):
		_choose_module_dialog.disconnect("on_module_choosed", self, i.method)
	
func _on_drone_color_btn_pressed():
	_input_color_dialog.visible = true
	
func _on_input_color_on_pick(_color):
	_input_color_btn_color.color = _color
	Global.player_drone_data.color = _color
	Global.player_drone_data.save_data(Global.player_drone_data_file)
	emit_signal("on_drone_data_change")


















































