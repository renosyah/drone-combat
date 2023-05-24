extends Control

signal on_score_press
signal on_menu_press

onready var _event_message = $event_message
onready var _tween = $Tween

onready var _overlay_map = $VBoxContainer/HBoxContainer/overlay_map

onready var _player_hp_bar = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar
onready var _player_name = $VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar/player_name

onready var _player_ammo_bar = $VBoxContainer/HBoxContainer/MarginContainer3/MarginContainer2/VBoxContainer2/ammo_bar_vertical
onready var _no_ammo_icon = $VBoxContainer/HBoxContainer/MarginContainer3/MarginContainer2/HBoxContainer/no_ammo_icon
onready var _ammo_icon = $VBoxContainer/HBoxContainer/MarginContainer3/MarginContainer2/HBoxContainer/ammo_icon

onready var _battle_time = $VBoxContainer/MarginContainer7/HBoxContainer/time

onready var _gui_elements = [
		$VBoxContainer/hbox/MarginContainer/HBoxContainer/VBoxContainer/player_hp_bar,
		$VBoxContainer/HBoxContainer/MarginContainer3/MarginContainer2,
		$VBoxContainer/HBoxContainer/overlay_map,
		$VBoxContainer/MarginContainer7/HBoxContainer
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	_event_message.modulate.a = 0.0
	_player_ammo_bar.set_hp_bar_color(Color.orange)
	_no_ammo_icon.visible = false
	_ammo_icon.visible = true
	set_gui_element_visible(true)
	
func display_event_message(text :String):
	_event_message.modulate.a = 1.0
	_event_message.text = text
	
	_tween.interpolate_property(_event_message, "modulate:a",_event_message.modulate.a, 0.0,3.5,Tween.TRANS_SINE)
	_tween.start()
	
func update_battle_time(time_left:int):
	_battle_time.text = Utils.format_time(time_left,  Utils.FORMAT_MINUTES | Utils.FORMAT_SECONDS, "%02d", ":")
	
func update_player_ammo_bar(ammo, max_ammo :int):
	_player_ammo_bar.update_bar(ammo, max_ammo)
	_no_ammo_icon.visible = ammo <= (max_ammo * 0.25)
	_ammo_icon.visible = not _no_ammo_icon.visible
	
func update_player_hp_bar(player_name :String, hp, max_hp :int):
	_player_name.text = player_name
	_player_hp_bar.update_bar(hp, max_hp)
	
func add_minimap_object_marker(object :Spatial, marker_icon:Resource, marker_color :Color):
	_overlay_map.add_object(object, marker_icon, marker_color)
	
func set_camera(_camera : GameplayCamera):
	_overlay_map.set_camera(_camera)
	
func set_gui_element_visible(show :bool):
	for i in _gui_elements:
		i.visible = show
	
func _on_button_menu_pressed():
	emit_signal("on_menu_press")
	
func _on_button_score_pressed():
	emit_signal("on_score_press")
	


