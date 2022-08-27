extends Control

signal on_joystick_input(output)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Virtual_joystick_on_joystick_input(output):
	emit_signal("on_joystick_input", output)
