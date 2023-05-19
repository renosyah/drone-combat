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
			"Renosyah"
		]
	},
	{
		"credit_name" : "3D model & Asset",
		"credit_details" : [
			"Renosyah",
			"Quaternius"
		]
	},
	{
		"credit_name" : "Campaign & map",
		"credit_details" : [
			"Renosyah"
		]
	},
	{
		"credit_name" : "Sound",
		"credit_details" : [
			"Renosyah"
		]
	},
	{
		"credit_name" : "About Me",
		"credit_details" : [
			"Reno Syahputra (Renosyah)",
		]
	},
	{
		"credit_name" : "Linkedin",
		"credit_details" : [
			"https://id.linkedin.com/in/reno-syahputra-839840142",
		]
	},
	{
		"credit_name" : "Facebook",
		"credit_details" : [
			"https://www.facebook.com/renosyah975"
		]
	},
	{
		"credit_name" : "Thank You",
		"credit_details" : [
			"Have A Nice Day"
		]
	},
]

onready var _holder = $CanvasLayer/Control/holder
onready var _main_menu_button = $CanvasLayer/Control/main_menu

func _ready():
	get_tree().set_quit_on_go_back(false)
	get_tree().set_auto_accept_quit(false)

	for i in credits:
		var item = preload("res://menu/credit-menu/ui/item/credit_item.tscn").instance()
		item.credit_name = i["credit_name"]
		item.credit_details = i["credit_details"]
		_holder.add_child(item)
		
		var margin = MarginContainer.new()
		margin.rect_min_size.y = 100
		_holder.add_child(margin)
		
	var m = MarginContainer.new()
	m.rect_min_size.y = 1000
	_holder.add_child(m)
	
	_main_menu_button.visible = false

func _process(delta):
	_holder.rect_position.y -= 50 * delta
	if _holder.rect_position.y < -2000:
		set_process(false)
		_on_main_menu_pressed()
		return

func _on_main_menu_pressed():
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")


func _on_Timer2_timeout():
	_main_menu_button.visible = true
