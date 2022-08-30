extends Control

signal on_joystick_input(output,is_pressed)
signal on_respawn_button_press()

const DEKSTOP =  ["Server", "Windows", "WinRT", "X11"]

onready var _is_dekstop :bool = OS.get_name() in DEKSTOP
onready var _joystick: VirtualJoystick = $CanvasLayer/control/joystick
onready var _control: Control = $CanvasLayer/control
onready var _death_screen: Control = $CanvasLayer/death_screen
onready var _mini_map = $CanvasLayer/MiniMap

# Called when the node enters the scene tree for the first time.
func _ready():
	show_control_screen()
	validate_input_by_platform()
	
func add_minimap_object(spawned):
	_mini_map.add_object(spawned)

func set_camera(_camera : GameplayCamera):
	_mini_map.set_camera(_camera)
	
func validate_input_by_platform():
	_joystick.visible = not _is_dekstop
	
func show_death_screen():
	_death_screen.visible = true
	_control.visible = false
	
func show_control_screen():
	_death_screen.visible = false
	_control.visible = true
	
func _on_Virtual_joystick_on_joystick_input(output, is_pressed):
	if _is_dekstop:
		return
		
	emit_signal("on_joystick_input", output, is_pressed)
	
func _unhandled_input(event):
	if not _is_dekstop:
		return
		
	var velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	emit_signal("on_joystick_input", velocity, true)
	
func _on_respawn_pressed():
	emit_signal("on_respawn_button_press")
	
