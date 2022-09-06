extends Control

signal on_score_press
signal on_menu_press

onready var _event_message = $event_message
onready var _tween = $Tween

onready var _overlay_map = $VBoxContainer/HBoxContainer/overlay_map

onready var _player_hp_bar = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar
onready var _player_ammo_bar = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_ammo_bar
onready var _player_name = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar/player_name

onready var _no_ammo_icon = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/no_ammo_icon
onready var _no_hp_icon = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/no_hp_icon

onready var _hurt_indicator = $hurt

# Called when the node enters the scene tree for the first time.
func _ready():
	_event_message.modulate.a = 0.0
	_player_ammo_bar.set_hp_bar_color(Color.orange)
	_no_ammo_icon.visible = false
	_no_hp_icon.visible = false
	
func display_event_message(text :String):
	_event_message.modulate.a = 1.0
	_event_message.text = text
	
	_tween.interpolate_property(_event_message, "modulate:a",_event_message.modulate.a, 0.0,3.5,Tween.TRANS_SINE)
	_tween.start()
	
func update_player_ammo_bar(ammo, max_ammo :int, ui_feedback :bool = true):
	_player_ammo_bar.update_bar(ammo, max_ammo)
	
	if not ui_feedback:
		return
		
	_no_ammo_icon.visible = ammo <= (max_ammo * 0.25)
	
func update_player_hp_bar(player_name :String, hp, max_hp :int, ui_feedback :bool = true):
	var is_critical = hp <= (max_hp * 0.25) and hp > 1
	_player_name.text = player_name
	_player_hp_bar.update_bar(hp, max_hp)
	
	if not ui_feedback:
		return
		
	_no_hp_icon.visible = is_critical
	_hurt_indicator.show_hurt(is_critical)
	
func add_minimap_object_marker(object :Spatial, marker_icon:Resource, marker_color :Color):
	_overlay_map.add_object(object, marker_icon, marker_color)
	
func set_camera(_camera : GameplayCamera):
	_overlay_map.set_camera(_camera)
	
func show_hurt():
	_hurt_indicator.show_hurt()
	
func _on_button_menu_pressed():
	emit_signal("on_menu_press")
	
func _on_button_score_pressed():
	emit_signal("on_score_press")
	


