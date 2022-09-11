extends Control

const ENABLE_BOT = true

const BUTTON_BATTLE_ENABLE_COLOR = Color(0, 0.592157, 0.035294)
const BUTTON_BATTLE_DISABLE_COLOR = Color(0.27451, 0.27451, 0.27451)

signal spawn_joined_player(index, players)
signal on_cicle_between_player(index)

var cicle_between_player_index = 0

onready var _server_advertise = $server_advertise
onready var _player_holder = $CanvasLayer/control/VBoxContainer/VBoxContainer2/VBoxContainer

onready var _play_button :BorderButton = $CanvasLayer/control/VBoxContainer/VBoxContainer2/HBoxContainer2/play
onready var _ready_button :BorderButton = $CanvasLayer/control/VBoxContainer/VBoxContainer2/HBoxContainer2/ready

onready var _add_bot_button_icon = $CanvasLayer/control/PanelContainer/HBoxContainer/add_bot/ColorRect2

onready var _exit_timer = $exit_timer

onready var _lobby_menu = $CanvasLayer/control
onready var _dialog_exit_option = $CanvasLayer/simple_dialog_option
onready var _loading = $CanvasLayer/simple_loading_dialog

################################################################
# sync lobby
var player_joined : Array = []

remote func _request_update_player_joined_status(from : int, data : Dictionary):
	for i in player_joined:
		if i["player_id"] == data["player_id"]:
			if i["flag"] == Global.PLAYER_STATUS_READY:
				return
				
			i["flag"] = Global.PLAYER_STATUS_READY
			i["status"] = "Ready"
			break
			
	rpc("_update_player_joined", player_joined)
	
remote func _request_append_player_joined(from : int, data : Dictionary):
	for i in player_joined:
		if i["player_id"] == data["player_id"]:
			player_joined.erase(i)
			break
			
	data["player_team"] = player_joined.size() + 1
	data["number"] = player_joined.size()
	player_joined.append(data)
	
	rpc("_update_player_joined", player_joined)
	
remote func _request_erase_player_joined(data : Dictionary):
	for i in player_joined:
		if i["player_id"] == data["player_id"]:
			player_joined.erase(i)
			break
			
	rpc("_update_player_joined", player_joined)
	
remotesync func _update_player_joined(data : Array):
	if is_server():
		_server_advertise.serverInfo["player"] = player_joined.size()
	else:
		player_joined = data
		
	player_joined.sort_custom(MyCustomSorter, "sort")
	
	validate_cicle_between_player(cicle_between_player_index)
	display_player_slot(cicle_between_player_index)
	emit_signal("spawn_joined_player",cicle_between_player_index, player_joined)
	
remotesync func _kick_player(data : Dictionary):
	for i in player_joined:
		if i["player_id"] == data["player_id"]:
			player_joined.erase(i)
			break
			
	if data["player_id"] == Global.player.player_id:
		Network.connect("connection_closed", self , "_got_kickout")
		Network.disconnect_from_server()
		return
		
	validate_cicle_between_player(cicle_between_player_index)
	display_player_slot(cicle_between_player_index)
	emit_signal("spawn_joined_player",cicle_between_player_index, player_joined)
	
################################################################
# Called when the node enters the scene tree for the first time.
func _ready():
	_play_button.visible = is_server()
	_play_button.disabled = true
	_play_button.button_color = BUTTON_BATTLE_DISABLE_COLOR
	
	_ready_button.visible = not is_server()
	_ready_button.button_color = BUTTON_BATTLE_ENABLE_COLOR
	
	_add_bot_button_icon.visible = ENABLE_BOT
	_show_loading(true)
	
	if is_server():
		_init_host()
	else:
		_init_join()
		
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
	
func _show_loading(loading :bool):
	_lobby_menu.visible = not loading
	_loading.visible = loading
	
################################################################
# host player section
func _init_host():
	Network.connect("server_player_connected", self ,"_server_player_connected")
	var err = Network.create_server(Global.server.max_player, Global.server.port,{"name" : Global.player.player_name})
	if err != OK:
		return
	
func _server_player_connected(_player_network_unique_id : int, _player : Dictionary):
	_show_loading(false)
	
	var player = Global.create_mp_player()
	player["status"] = "Ready"
	player["flag"] = Global.PLAYER_STATUS_READY
	_request_append_player_joined(Global.client.network_unique_id, player)
	
	_server_advertise.setup()
	_server_advertise.serverInfo["name"] = Global.player.player_name
	_server_advertise.serverInfo["port"] = Global.server.port
	_server_advertise.serverInfo["public"] = true
	_server_advertise.serverInfo["player"] = player_joined.size()
	_server_advertise.serverInfo["max_player"] = Global.server.max_player
	
################################################################
# join player section
func _init_join():
	Global.connect("on_host_game_session_ready", self, "_on_host_game_session_ready")
	Network.connect("server_disconnected", self , "_server_disconnected")
	Network.connect("client_player_connected", self , "_client_player_connected")
	
	var err = Network.connect_to_server(Global.client.ip, Global.client.port , {"name" : Global.player.player_name})
	if err != OK:
		return
	
func _client_player_connected(_player_network_unique_id : int, _player : Dictionary):
	_show_loading(false)
	Global.client.network_unique_id = _player_network_unique_id
	rpc_id(Network.PLAYER_HOST_ID, "_request_append_player_joined", Global.client.network_unique_id, Global.create_mp_player())
	
func _on_host_game_session_ready(_mp_game_data : Dictionary):
	Global.mp_game_data = _mp_game_data
	Global.mp_players = player_joined
	get_tree().change_scene("res://gameplay/mp/client/battle.tscn")
	
func _server_disconnected():
	Global.mp_exception_message = "Unexpected exit by Server!"
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
func _got_kickout():
	Global.mp_exception_message = "You have been kickout by host!"
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")

################################################################
# ui action
func _on_ready_pressed():
	_ready_button.button_color = BUTTON_BATTLE_DISABLE_COLOR
	set_player_ready()
	
func _on_play_pressed():
	if not is_server():
		return
		
	if not is_all_player_ready():
		return
		
	Global.mp_players = player_joined
	get_tree().change_scene("res://gameplay/mp/host/battle.tscn")
	
func _on_add_bot_pressed():
	if not is_server():
		return
		
	if not ENABLE_BOT:
		return
		
	if player_joined.size() >= Global.server.max_player:
		return
		
	_request_append_player_joined(Network.PLAYER_HOST_ID, Global.create_bot_player())
	
func display_player_slot(index :int):
	for i in _player_holder.get_children():
		_player_holder.remove_child(i)
	
	_play_button.disabled = not is_all_player_ready() or not is_team_valid()
	_play_button.button_color = BUTTON_BATTLE_DISABLE_COLOR if (_play_button.disabled) else BUTTON_BATTLE_ENABLE_COLOR
	_add_bot_button_icon.visible = ENABLE_BOT and is_server() and player_joined.size() < Global.server.max_player
	
	var player = player_joined[index]
	var item = preload("res://menu/lobby-menu/ui/item/item.tscn").instance()
	item.data = player
	item.can_kick = (player["player_id"] != Global.player.player_id and is_server())
	item.can_switch_team = is_server()
	item.connect("kick", self, "_on_player_get_kick")
	item.connect("change_team", self, "_on_player_change_team")
	_player_holder.add_child(item)
	
func set_player_ready():
	if is_server():
		return
		
	rpc_id(Network.PLAYER_HOST_ID, "_request_update_player_joined_status", Global.client.network_unique_id, Global.create_mp_player())
	
func _on_player_change_team(_player):
	if not is_server():
		return
		
	_player["player_team"] += 1
		
	if _player["player_team"] > 4:
		_player["player_team"] = 1
	
	rpc("_update_player_joined", player_joined)
	
func _on_player_get_kick(_player):
	if not is_server():
		return
		
	rpc("_kick_player", _player)
	
func _on_prev_pressed():
	validate_cicle_between_player(cicle_between_player_index + 1)
	display_player_slot(cicle_between_player_index)
	emit_signal("on_cicle_between_player", cicle_between_player_index)
	
func _on_next_pressed():
	validate_cicle_between_player(cicle_between_player_index - 1)
	display_player_slot(cicle_between_player_index)
	emit_signal("on_cicle_between_player", cicle_between_player_index)
	
func _on_back_pressed():
	_dialog_exit_option.display_message("Attention!","Are you sure want back to main menu?")
	_dialog_exit_option.visible = true
	
func _on_simple_dialog_option_on_yes():
	if is_server():
		_on_exit_timer_timeout()
		return
		
	_exit_timer.start()
	rpc("_request_erase_player_joined", Global.create_mp_player())
	
func _on_exit_timer_timeout():
	Network.disconnect_from_server()
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
################################################################
# utils
class MyCustomSorter:
	static func sort(a, b):
		if a["number"] < b["number"]:
			return true
		return false
		
func is_server():
	return Global.mode == Global.MODE_HOST
	
func is_all_player_ready() -> bool:
	if player_joined.size() == 1:
		return false
		
	for i in player_joined:
		if i["flag"] == Global.PLAYER_STATUS_NOT_READY:
			return false
	return true
	
func is_team_valid() -> bool:
	var team = {}
		
	for i in player_joined:
		team[i["player_team"]] = 1
		
	if team.size() == 1:
		return false
	
	return true
	
	
func validate_cicle_between_player(idx :int):
	cicle_between_player_index = idx
	
	if cicle_between_player_index > player_joined.size() - 1:
		cicle_between_player_index = 0
		
	elif cicle_between_player_index < 0:
		cicle_between_player_index = player_joined.size() - 1


































