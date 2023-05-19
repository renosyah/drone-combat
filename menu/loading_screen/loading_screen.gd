extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Admob.connect("initialization_finish", self ,"_initialization_finish")
	Admob.initialize()
	
func _initialization_finish():
	get_tree().change_scene("res://menu/main-menu/main_menu.tscn")

