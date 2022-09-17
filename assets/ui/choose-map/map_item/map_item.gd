extends VBoxContainer

const BUTTON_ENABLE_COLOR = Color(0, 0.592157, 0.035294)
const BUTTON_DISABLE_COLOR = Color(0.27451, 0.27451, 0.27451)

signal on_map_choosed(_map_data)

var map_data :MapData

onready var _map_name = $Control/VBoxContainer/MarginContainer/VBoxContainer/map_name
onready var _map_image = $Control/map_icon

onready var _button_mount = $mount
onready var _button_color = $mount/ColorRect
onready var _button_label =  $mount/Label

onready var _info_holder = $Control/VBoxContainer/MarginContainer/VBoxContainer
onready var _locked = $Control/locked

# Called when the node enters the scene tree for the first time.
func _ready():
	_map_name.text = map_data.map_name
	_map_image.texture = load(map_data.map_icon)
	
	var is_unlocked = is_unlocked()
	_locked.visible = not is_unlocked
	_button_label.text = "Select" if is_unlocked else "Locked"
	
	if is_unlocked:
		_button_mount.disabled = false
		_button_color.color = BUTTON_ENABLE_COLOR
	else:
		_button_mount.disabled = true
		_button_color.color = BUTTON_DISABLE_COLOR
		
func _on_mount_pressed():
	emit_signal("on_map_choosed", map_data)
	
func is_unlocked() -> bool:
	return map_data.map_id in Global.player_unlocked_maps
	


