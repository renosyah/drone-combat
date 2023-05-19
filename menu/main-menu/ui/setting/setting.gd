extends Control

onready var _sfx_sound_setting_icon = $VBoxContainer2/HBoxContainer2/sfx_setting/TextureRect
onready var _screen_orientation_setting_icon = $VBoxContainer2/HBoxContainer4/orientation_setting/TextureRect
onready var _dynamic_joystick_setting_icon = $VBoxContainer2/HBoxContainer5/dynamic_joystic_setting/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	check_sfx_setting()
	check_dynamic_joystick_setting()
	#check_orientation_setting()
	
func check_sfx_setting():
	if not Global.setting_data.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_check.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_uncheck.png")
		
func check_orientation_setting():
	if OS.screen_orientation == OS.SCREEN_ORIENTATION_PORTRAIT:
		_screen_orientation_setting_icon.texture = preload("res://assets/ui/icon/checkbox_check.png")
		OS.set_window_size(Vector2(600, 1024))
	else:
		OS.set_window_size(Vector2(1024,600))
		_screen_orientation_setting_icon.texture = preload("res://assets/ui/icon/checkbox_uncheck.png")
	
func check_dynamic_joystick_setting():
	if not Global.setting_data.is_joystick_fixed:
		_dynamic_joystick_setting_icon.texture = preload("res://assets/ui/icon/checkbox_check.png")
	else:
		_dynamic_joystick_setting_icon.texture = preload("res://assets/ui/icon/checkbox_uncheck.png")
		
	
func _on_sfx_setting_pressed():
	Global.setting_data.is_sfx_mute = not Global.setting_data.is_sfx_mute
	Global.apply_setting_data()
	check_sfx_setting()
	
func _on_orientation_setting_pressed():
	var is_potrait = OS.screen_orientation == OS.SCREEN_ORIENTATION_PORTRAIT
	OS.screen_orientation = OS.SCREEN_ORIENTATION_PORTRAIT if not is_potrait else OS.SCREEN_ORIENTATION_LANDSCAPE
	check_orientation_setting()
	
func _on_dynamic_joystic_setting_pressed():
	Global.setting_data.is_joystick_fixed = not Global.setting_data.is_joystick_fixed
	Global.apply_setting_data()
	check_dynamic_joystick_setting()
	
func _on_close_pressed():
	visible = false

