extends HBoxContainer

var score_data :ScoreData

onready var _color = $MarginContainer/color
onready var _player_name = $MarginContainer2/player_name
onready var _kill_count = $MarginContainer3/kill_count
onready var _death_count = $MarginContainer4/death_count

# Called when the node enters the scene tree for the first time.
func _ready():
	if not score_data:
		return
		
	_color.color = score_data.player_color
	_player_name.text = score_data.player_name
	_kill_count.text = str(score_data.kill_count)
	_death_count.text = str(score_data.death_count)
