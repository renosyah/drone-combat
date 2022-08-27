extends Node
class_name BattleSp

func _ready():
	Global.apply_players_unit_team()
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
