extends Control

signal on_joystick_input(output,is_pressed)
signal on_respawn_button_press()

onready var _joystick = $CanvasLayer/control/joystick
onready var _control = $CanvasLayer/control
onready var _death_screen = $CanvasLayer/death_screen


# Called when the node enters the scene tree for the first time.
func _ready():
	show_control_screen()
	
func show_death_screen():
	_death_screen.visible = true
	_control.visible = false
	
func show_control_screen():
	_death_screen.visible = false
	_control.visible = true
	
func _on_Virtual_joystick_on_joystick_input(output, is_pressed):
	emit_signal("on_joystick_input", output, is_pressed)
	
func _on_respawn_pressed():
	emit_signal("on_respawn_button_press")
