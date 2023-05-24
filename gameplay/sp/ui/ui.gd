extends Control

signal on_joystick_input(output,is_pressed)
signal exit_game_session
signal on_open_credit
signal on_restart_mission_press
signal on_next_mission_press

var is_player_alive = true

onready var _gui = $CanvasLayer/SafeArea/gui
onready var _joystick = $CanvasLayer/SafeArea/joystick
onready var _battle_end = $CanvasLayer/SafeArea/battle_end
onready var _unlocked_notification = $CanvasLayer/unlocked_notification
onready var _menu = $CanvasLayer/SafeArea/menu
onready var _hurt = $CanvasLayer/hurt

onready var _dialog_exit = $CanvasLayer/SafeArea/simple_dialog_on_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	_battle_end.visible = false
	_gui.visible = true
	_joystick.visible = true
	_dialog_exit.visible = false
	_menu.visible = false
	_unlocked_notification.visible = false

	
func update_player_ammo_bar(ammo, max_ammo :int):
	_gui.update_player_ammo_bar(ammo, max_ammo)
	
func update_player_hp_bar(player_name :String, hp, max_hp :int):
	_gui.update_player_hp_bar(player_name, hp, max_hp)
	
func add_minimap_object_marker(object :Spatial, marker_icon:Resource, marker_color :Color):
	_gui.add_minimap_object_marker(object, marker_icon, marker_color)
	
func remove_minimap_object_marker(object :Spatial):
	_gui.remove_minimap_object_marker(object)
	
func set_camera(_camera : GameplayCamera):
	_gui.set_camera(_camera)
	
func show_hurt(type :int):
	match type:
		1:
			_hurt.show_hurt()
		2:
			_hurt.show_hurting()
		3:
			_hurt.hide_hurt()
			
func show_mission_is_success():
	_gui.set_gui_element_visible(false)
	_joystick.visible = false
	_battle_end.visible = true
	_battle_end.set_mission_is_success()
	
func show_mission_is_failed():
	_gui.set_gui_element_visible(false)
	_joystick.visible = false
	_battle_end.visible = true
	_battle_end.set_mission_is_failed()
	
func show_campaign_finish():
	_gui.set_gui_element_visible(false)
	_joystick.visible = false
	_battle_end.visible = true
	_battle_end.set_campaign_finish()
	
func show_unlocked_item(title :String, item_unlocked :Resource):
	_unlocked_notification.title = title
	_unlocked_notification.item_unlocked = item_unlocked
	_unlocked_notification.show_unlocked_item()
	
func _on_menu_on_main_menu_press():
	_dialog_exit.visible = true
	
func _on_simple_dialog_on_exit_on_yes():
	emit_signal("exit_game_session")
	
func _on_battle_end_on_exit_press():
	emit_signal("exit_game_session")
	
func _on_gui_on_menu_press():
	_menu.visible = true
	
func _on_joystick_on_joystick_input(output, is_pressed):
	emit_signal("on_joystick_input", output, is_pressed)
	
func _on_battle_end_on_credit_press():
	emit_signal("on_open_credit")
	
func _on_battle_end_on_next_mission_press():
	emit_signal("on_next_mission_press")
	
func _on_battle_end_on_restart_mission_press():
	emit_signal("on_restart_mission_press")

 



















