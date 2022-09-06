extends Control

signal on_main_menu_press

onready var _sfx_sound_setting_icon = $VBoxContainer2/HBoxContainer2/sfx_setting/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	check_sfx_setting()
	
func _on_sfx_setting_pressed():
	Global.is_sfx_mute = not Global.is_sfx_mute
	check_sfx_setting()
	
func check_sfx_setting():
	if not Global.is_sfx_mute:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_check.png")
	else:
		_sfx_sound_setting_icon.texture = preload("res://assets/ui/icon/checkbox_uncheck.png")
	
func _on_resume_pressed():
	visible = false
	
func _on_exit_pressed():
	emit_signal("on_main_menu_press")
