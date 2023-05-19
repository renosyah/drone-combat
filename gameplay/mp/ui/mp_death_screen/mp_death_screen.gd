extends Control

signal on_respawn_press
signal on_next_press
signal on_previous_press

const BUTTON_RESPAWN_ENABLE_COLOR = Color(0.619608, 0.105882, 0.105882)
const BUTTON_RESPAWN_DISABLE_COLOR = Color(0.402344, 0.402344, 0.402344)

onready var _label = $VBoxContainer/Label
onready var _respawn_btn :BorderButton = $VBoxContainer/HBoxContainer/respawn
onready var _respawn_timer = $respawn_timer

func _ready():
	set_process(false)
	
func _process(delta):
	if _respawn_timer.is_stopped():
		_respawn_btn.button_label = "Respawn"
		_respawn_btn.disabled = false
		_respawn_btn.button_color = BUTTON_RESPAWN_ENABLE_COLOR
		set_process(false)
		
	else:
		_respawn_btn.button_label = "Wait (" + str(int(_respawn_timer.time_left + 1)) + ")"
		_respawn_btn.disabled = true
		_respawn_btn.button_color = BUTTON_RESPAWN_DISABLE_COLOR
		
func set_respawn_time(time :int):
	_respawn_timer.wait_time = time
	_respawn_timer.one_shot = true
	
func show_death_screen():
	_respawn_timer.start()
	set_process(true)
	visible = true
	
func _on_respawn_pressed():
	visible = false
	emit_signal("on_respawn_press")
	
func _on_prev_pressed():
	emit_signal("on_previous_press")
	
func _on_next_pressed():
	emit_signal("on_next_press")
	
