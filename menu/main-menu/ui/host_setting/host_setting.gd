extends Control

signal create

onready var _battle_time_short_unselected_bg = $VBoxContainer2/VBoxContainer2/HBoxContainer3/short/Color
onready var _battle_time_normal_unselected_bg = $VBoxContainer2/VBoxContainer2/HBoxContainer3/normal/Color
onready var _battle_time_long_unselected_bg = $VBoxContainer2/VBoxContainer2/HBoxContainer3/long/Color

onready var _respawn_time_short_unselected_bg = $VBoxContainer2/VBoxContainer3/HBoxContainer3/respawn_short/Color
onready var _respawn_time_normal_unselected_bg = $VBoxContainer2/VBoxContainer3/HBoxContainer3/respawn_normal/Color
onready var _respawn_time_long_unselected_bg = $VBoxContainer2/VBoxContainer3/HBoxContainer3/respawn_long/Color


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_unselected_battle_time()
	_battle_time_short_unselected_bg.visible = false
	
	hide_all_unselected_respawn_time()
	_respawn_time_short_unselected_bg.visible = false
	
func _on_close_pressed():
	visible = false
	
func _on_create_pressed():
	emit_signal("create")
	
func hide_all_unselected_battle_time():
	_battle_time_short_unselected_bg.visible = true
	_battle_time_normal_unselected_bg.visible = true
	_battle_time_long_unselected_bg.visible = true
	
func hide_all_unselected_respawn_time():
	_respawn_time_short_unselected_bg.visible = true
	_respawn_time_normal_unselected_bg.visible = true
	_respawn_time_long_unselected_bg.visible = true
	

func _on_short_pressed():
	Global.mp_game_data["battle_time"] = 300
	hide_all_unselected_battle_time()
	_battle_time_short_unselected_bg.visible = false
	
func _on_normal_pressed():
	Global.mp_game_data["battle_time"] = 600
	hide_all_unselected_battle_time()
	_battle_time_normal_unselected_bg.visible = false
	
func _on_long_pressed():
	Global.mp_game_data["battle_time"] = 900
	hide_all_unselected_battle_time()
	_battle_time_long_unselected_bg.visible = false


func _on_respawn_short_pressed():
	Global.mp_game_data["respawn_time"] = 15
	hide_all_unselected_respawn_time()
	_respawn_time_short_unselected_bg.visible = false


func _on_respawn_normal_pressed():
	Global.mp_game_data["respawn_time"] = 20
	hide_all_unselected_respawn_time()
	_respawn_time_normal_unselected_bg.visible = false


func _on_respawn_long_pressed():
	Global.mp_game_data["respawn_time"] = 25
	hide_all_unselected_respawn_time()
	_respawn_time_long_unselected_bg.visible = false
