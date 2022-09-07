extends Control

signal on_joystick_input(output,is_pressed)
signal on_respawn_button_press()
signal on_spectate_previous()
signal on_spectate_next()
signal exit_game_session()

var is_player_alive = true

onready var _gui = $CanvasLayer/gui
onready var _joystick = $CanvasLayer/joystick
onready var _mp_death_screen = $CanvasLayer/mp_death_screen
onready var _scoreboard = $CanvasLayer/scoreboard
onready var _menu = $CanvasLayer/menu

onready var _dialog_exit = $CanvasLayer/simple_dialog_on_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	_gui.visible = true
	_joystick.visible = true
	_mp_death_screen.visible = false
	_dialog_exit.visible = false
	_scoreboard.visible = false
	_menu.visible = false
	
func set_respawn_time(time :int):
	_mp_death_screen.set_respawn_time(time)
	
func update_scoreboard(player_id, kill, death :int, _color :Color = Color.white, player_name :String = ""):
	_scoreboard.update_scoreboard(player_id, kill, death, _color, player_name)
	
func display_event_message(text :String):
	if not is_player_alive:
		return
		
	_gui.display_event_message(text)
	
func update_player_ammo_bar(ammo, max_ammo :int, ui_feedback :bool= true):
	_gui.update_player_ammo_bar(ammo, max_ammo, ui_feedback)
	
func update_player_hp_bar(player_name :String, hp, max_hp :int, ui_feedback :bool= true):
	_gui.update_player_hp_bar(player_name, hp, max_hp, ui_feedback)
	
func add_minimap_object_marker(object :Spatial, marker_icon:Resource, marker_color :Color):
	_gui.add_minimap_object_marker(object, marker_icon, marker_color)
	
func set_camera(_camera : GameplayCamera):
	_gui.set_camera(_camera)
	
func show_hurt():
	_gui.show_hurt()
	
func show_death_screen():
	is_player_alive = false
	_gui.set_gui_element_visible(is_player_alive)
	_joystick.visible = is_player_alive
	_mp_death_screen.show_death_screen()
	
func _on_menu_on_main_menu_press():
	_dialog_exit.visible = true
	
func _on_simple_dialog_on_exit_on_yes():
	emit_signal("exit_game_session")

func _on_mp_death_screen_on_next_press():
	emit_signal("on_spectate_next")
	
func _on_mp_death_screen_on_previous_press():
	emit_signal("on_spectate_previous")
	
func _on_mp_death_screen_on_respawn_press():
	is_player_alive = true
	_gui.set_gui_element_visible(is_player_alive)
	_joystick.visible = is_player_alive
	emit_signal("on_respawn_button_press")
	
func _on_gui_on_menu_press():
	_menu.visible = true
	
func _on_gui_on_score_press():
	_scoreboard.visible = true
	
func _on_joystick_on_joystick_input(output, is_pressed):
	emit_signal("on_joystick_input", output, is_pressed)







 


