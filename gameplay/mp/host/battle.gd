extends BattleMp

var drone : BaseHull

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	Global.on_host_game_session_ready()
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	if not is_instance_valid(drone):
		return
		
	._move_drone(drone.get_path(), output)
	
################################################################
# drone event handler
func on_drone_dead(_entity):
	.on_drone_dead(_entity)
	
	if _entity != drone:
		return
		
	if not _entity.is_dead():
		return
		
	_ui.show_death_screen()
	
################################################################
# ui event handler
func on_respawn_button_press():
	.on_respawn_button_press()
	_ui.show_control_screen()
	
	if not is_instance_valid(drone):
		return
		
	.respawn_drone(drone.get_path())
	
################################################################
# process
func _process(delta):
	if not is_instance_valid(drone):
		return
	
	_camera.translation = drone.global_transform.origin
	

