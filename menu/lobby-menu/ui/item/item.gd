extends Control

signal kick(_data)

onready var _color = $HBoxContainer/team_color
onready var _name = $HBoxContainer/VBoxContainer/player_name
onready var _status = $HBoxContainer/VBoxContainer/Label
onready var _kick_btn = $HBoxContainer/panel
onready var _panel_kick = $HBoxContainer/panel/kick_player

var can_kick = false
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_color.color = data.color
	_name.text = data.player_name
	_status.text = data.status
	_panel_kick.visible = can_kick

func _on_kick_player_pressed():
	emit_signal("kick",data)
