extends MarginContainer

signal on_restart_mission_press
signal on_next_mission_press
signal on_credit_press

onready var _title = $VBoxContainer2/HBoxContainer/Label2
onready var _next_button_layout = $VBoxContainer2/HBoxContainer3/HBoxContainer
onready var _button_layout = $VBoxContainer2/HBoxContainer3
onready var _button_exit_layout = $VBoxContainer2/HBoxContainer4

func _ready():
	_button_exit_layout.visible = false

func set_mission_is_success():
	_title.text = "Mission Completed"
	_next_button_layout.visible = true
	
func set_mission_is_failed():
	_title.text = "Mission Failed"
	_next_button_layout.visible = false
	
func set_campaign_finish():
	_title.text = "Campaign Completed"
	_button_layout.visible = false
	_button_exit_layout.visible = true
	
func _on_restart_pressed():
	emit_signal("on_restart_mission_press")
	
func _on_next_pressed():
	emit_signal("on_next_mission_press")

func _on_credit_pressed():
	emit_signal("on_credit_press")
