extends Control

var credits = [
	{
		"credit_name" : "Drone Combat",
		"credit_details" : [
			""
		]
	},
	{
		"credit_name" : "Made using",
		"credit_details" : [
			"Godot Game Engine v3.4"
		]
	},
	{
		"credit_name" : "Creator",
		"credit_details" : [
			"Reno Syahputra (renosyah)"
		]
	},
	{
		"credit_name" : "3D model & Asset",
		"credit_details" : [
			"Reno Syahputra (renosyah)"
		]
	},
	{
		"credit_name" : "Campaign & map",
		"credit_details" : [
			"Reno Syahputra (renosyah)"
		]
	},
	{
		"credit_name" : "Sound",
		"credit_details" : [
			"Reno Syahputra (renosyah)"
		]
	},
]

var credit_queue_pos = 0

onready var _holder = $CanvasLayer/Control/holder
onready var _main_menu_button = $CanvasLayer/Control/main_menu

func _ready():
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)
	
	_on_Timer_timeout()
	_main_menu_button.visible = false

func _on_Timer_timeout():
	
	if credit_queue_pos > credits.size() - 1:
		return
		
	var item = preload("res://menu/credit-menu/ui/item/credit_item.tscn").instance()
	item.credit_name = credits[credit_queue_pos]["credit_name"]
	item.credit_details = credits[credit_queue_pos]["credit_details"]
	_holder.add_child(item)
	item.rect_position.y = 1000
	
	credit_queue_pos += 1
	
func _on_main_menu_pressed():
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")


func _on_Timer2_timeout():
	_main_menu_button.visible = true
