extends Control

signal change_team(_data)
signal kick(_data)

onready var _color = $HBoxContainer/team_button/team_color
onready var _name = $HBoxContainer/VBoxContainer/player_name
onready var _team = $HBoxContainer/team_button/VBoxContainer/player_team
onready var _status = $HBoxContainer/VBoxContainer/Label
onready var _kick_btn = $HBoxContainer/panel
onready var _panel_kick = $HBoxContainer/panel/kick_player

var can_kick = false
var can_switch_team = false
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_color.color = data.color
	_name.text = data.player_name
	_team.text = str(data.player_team)
	_status.text = data.status
	_panel_kick.visible = can_kick
	
func _on_kick_player_pressed():
	if not can_kick:
		return
		
	emit_signal("kick", data)
	
	
func _on_team_button_pressed():
	if not can_switch_team:
		return
		
	emit_signal("change_team", data)
