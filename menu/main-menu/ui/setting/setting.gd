extends Control

onready var _sfx_sound_setting_icon = $VBoxContainer2/HBoxContainer2/sfx_setting/TextureRect
onready var _screen_orientation_setting_icon = $VBoxContainer2/HBoxContainer4/orientation_setting/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	check_sfx_setting()
	#check_orientation_setting()
	
func check_sfx_setting():
	if not Global.is_sfx_mute:
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
	
func _on_sfx_setting_pressed():
	Global.is_sfx_mute = not Global.is_sfx_mute
	check_sfx_setting()
	
func _on_orientation_setting_pressed():
	var is_potrait = OS.screen_orientation == OS.SCREEN_ORIENTATION_PORTRAIT
	OS.screen_orientation = OS.SCREEN_ORIENTATION_PORTRAIT if not is_potrait else OS.SCREEN_ORIENTATION_LANDSCAPE
	check_orientation_setting()
	
func _on_close_pressed():
	visible = false

