extends Control

 
signal on_joystick_input(output,is_pressed)

onready var _is_dekstop :bool = OS.get_name() in Global.DEKSTOP
onready var _joystick: VirtualJoystick = $joystick

# Called when the node enters the scene tree for the first time.
func _ready():
	_joystick.visible = false
	if _is_dekstop:
		return

	_joystick.visible = true
	_joystick.joystick_mode = VirtualJoystick.JoystickMode.FIXED if Global.setting_data.is_joystick_fixed else VirtualJoystick.JoystickMode.DYNAMIC
	_joystick.connect("on_joystick_input", self, "_on_joystick_on_joystick_input")
	
	
func _on_joystick_on_joystick_input(output, is_pressed):
	emit_signal("on_joystick_input", output, is_pressed)
	
func _unhandled_input(event):
	if not _is_dekstop:
		return
		
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	emit_signal("on_joystick_input", velocity, true)
	
