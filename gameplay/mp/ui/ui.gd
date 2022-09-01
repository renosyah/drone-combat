extends Control

signal on_joystick_input(output,is_pressed)
signal on_respawn_button_press()

const DEKSTOP =  ["Server", "Windows", "WinRT", "X11"]

onready var _is_dekstop :bool = OS.get_name() in DEKSTOP

onready var _joystick: VirtualJoystick = $CanvasLayer/control/joystick
onready var _control: Control = $CanvasLayer/control
onready var _death_screen: Control = $CanvasLayer/death_screen
onready var _menu = $CanvasLayer/menu

onready var _mini_map = $CanvasLayer/MiniMap
onready var _player_name = $CanvasLayer/control/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar/player_name
onready var _player_hp_bar = $CanvasLayer/control/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar

onready var _sfx_sound_setting_icon = $CanvasLayer/menu/VBoxContainer2/HBoxContainer2/sfx_setting/TextureRect

onready var _dialog_exit = $CanvasLayer/simple_dialog_on_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	show_control_screen()
	validate_input_by_platform()
	
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_on.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_off.png")
	
	
func update_player_hp_bar(player_name :String, hp, max_hp :int):
	_player_name.text = player_name
	_player_hp_bar.update_bar(hp, max_hp)
	
func add_minimap_object(spawned):
	_mini_map.add_object(spawned)

func set_camera(_camera : GameplayCamera):
	_mini_map.set_camera(_camera)
	
func validate_input_by_platform():
	_joystick.visible = not _is_dekstop
	
func show_death_screen():
	_menu.visible = false
	_control.visible = false
	_death_screen.visible = true
	
func show_control_screen():
	_death_screen.visible = false
	_menu.visible = false
	_control.visible = true
	
func show_menu_screen():
	_death_screen.visible = false
	_control.visible = false
	_menu.visible = true
	
func _on_sfx_setting_pressed():
	Global.is_sfx_mute = not Global.is_sfx_mute
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_on.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/sound_off.png")
	
func _on_button_menu_pressed():
	show_menu_screen()
	
func _on_button_close_menu_pressed():
	show_control_screen()
	
func _on_Virtual_joystick_on_joystick_input(output, is_pressed):
	if _is_dekstop:
		return
		
	emit_signal("on_joystick_input", output, is_pressed)
	
func _unhandled_input(event):
	if not _is_dekstop:
		return
		
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	emit_signal("on_joystick_input", velocity, true)
	
func _on_respawn_pressed():
	emit_signal("on_respawn_button_press")
	
func _on_exit_pressed():
	_dialog_exit.visible = true
	
func exit_game_session():
	Network.disconnect_from_server()
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")
	
func _on_simple_dialog_on_exit_on_yes():
	exit_game_session()
	
	
	









