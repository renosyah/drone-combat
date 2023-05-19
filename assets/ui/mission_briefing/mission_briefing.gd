extends Control

onready var _mission_name = $CanvasLayer/Control/VBoxContainer/Label2
onready var _mission_objective = $CanvasLayer/Control/VBoxContainer/Label3
onready var _timer = $Timer
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_mission_name.text = '"' + Global.sp_game_data.mission_name + '"'
	_mission_objective.text = Global.sp_game_data.mission_objective
	_timer.start()
	
func _on_Timer_timeout():
	get_tree().change_scene("res://gameplay/sp/battle_sp.tscn")
