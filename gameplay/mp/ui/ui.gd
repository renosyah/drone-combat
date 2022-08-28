extends Control

signal on_joystick_input(output,is_pressed)

onready var _joystick = $CanvasLayer/Control/joystick

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Virtual_joystick_on_joystick_input(output, is_pressed):
	emit_signal("on_joystick_input", output, is_pressed)
