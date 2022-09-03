extends Control

const BUTTON_RESPAWN_ENABLE_COLOR = Color(0.619608, 0.105882, 0.105882)
const BUTTON_RESPAWN_DISABLE_COLOR = Color(0.402344, 0.402344, 0.402344)
const DEKSTOP =  ["Server", "Windows", "WinRT", "X11"]

signal on_joystick_input(output,is_pressed)
signal on_respawn_button_press()
signal on_spectate_previous()
signal on_spectate_next()

var respawn_time:float = 10.0

onready var _is_dekstop :bool = OS.get_name() in DEKSTOP

onready var _joystick: VirtualJoystick = $CanvasLayer/control/joystick
onready var _control: Control = $CanvasLayer/control
onready var _death_screen: Control = $CanvasLayer/death_screen
onready var _scoreboard = $CanvasLayer/scoreboard
onready var _menu = $CanvasLayer/menu

onready var _event_message = $CanvasLayer/control/event_message
onready var _tween = $CanvasLayer/Tween

onready var _respawn_btn = $CanvasLayer/death_screen/VBoxContainer/HBoxContainer/respawn
onready var _respawn_btn_color = $CanvasLayer/death_screen/VBoxContainer/HBoxContainer/respawn/ColorRect
onready var _respawn_btn_label = $CanvasLayer/death_screen/VBoxContainer/HBoxContainer/respawn/Label
onready var _respawn_timer = $CanvasLayer/respawn_timer

onready var _mini_map = $CanvasLayer/control/MiniMap
onready var _player_name = $CanvasLayer/control/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar/player_name
onready var _player_hp_bar = $CanvasLayer/control/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar

onready var _sfx_sound_setting_icon = $CanvasLayer/menu/VBoxContainer2/HBoxContainer2/sfx_setting/TextureRect

onready var _dialog_exit = $CanvasLayer/simple_dialog_on_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	show_control_screen()
	validate_input_by_platform()
	check_sfx_setting()
	
func _process(delta):
	if _respawn_timer.is_stopped():
		_respawn_btn_label.text = "Respawn"
		set_process(false)
		
	else:
		_respawn_btn_label.text = "Wait (" + str(int(_respawn_timer.time_left - 1)) + ")"
	
func update_scoreboard(player_id, kill, death :int, _color :Color = Color.white, player_name :String = ""):
	var score :ScoreData = ScoreData.new()
	score.player_color = _color
	score.player_id = player_id
	score.player_name = player_name
	score.kill_count = kill
	score.death_count = death
	_scoreboard.update_score(score)
	
func display_event_message(text :String):
	_event_message.modulate.a = 1.0
	_event_message.text = text
	
	_tween.interpolate_property(_event_message, "modulate:a",_event_message.modulate.a, 0.0,3.5,Tween.TRANS_SINE)
	_tween.start()
	
func update_player_hp_bar(player_name :String, hp, max_hp :int):
	_player_name.text = player_name
	_player_hp_bar.update_bar(hp, max_hp)
	
func add_minimap_object(object :Spatial, is_friendly :bool):
	_mini_map.add_object(object, is_friendly)

func set_camera(_camera : GameplayCamera):
	_mini_map.set_camera(_camera)
	
func validate_input_by_platform():
	_joystick.visible = not _is_dekstop
	
func show_death_screen():
	_respawn_timer.wait_time = respawn_time
	_respawn_timer.start()
	set_process(true)
	
	_control.visible = false
	_death_screen.visible = true
	
	_respawn_btn.disabled = true
	_respawn_btn_color.color = BUTTON_RESPAWN_DISABLE_COLOR
	
	yield(_respawn_timer,"timeout")
	
	_respawn_btn.disabled = false
	_respawn_btn_color.color = BUTTON_RESPAWN_ENABLE_COLOR
	
func show_control_screen():
	_death_screen.visible = false
	_control.visible = true
	
func show_menu_screen():
	_death_screen.visible = false
	_control.visible = false
	
func check_sfx_setting():
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_check.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_uncheck.png")
	
func _on_sfx_setting_pressed():
	Global.is_sfx_mute = not Global.is_sfx_mute
	check_sfx_setting()
	
func _on_button_menu_pressed():
	_menu.visible = true
	
func _on_button_resume_menu_pressed():
	_menu.visible = false
	
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
	
func _on_prev_pressed():
	emit_signal("on_spectate_previous")
	
func _on_next_pressed():
	emit_signal("on_spectate_next")
	
func _on_button_score_pressed():
	_scoreboard.visible = true


















