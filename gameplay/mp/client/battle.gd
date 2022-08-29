extends BattleMp

var command : Vector2
var drone : BaseHull
onready var respawn_delay_timer : Timer = $respawn_delay_timer

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	init_client()
	.load_map_stuff()
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	command = output
	
func on_client_pool_network_request():
	.on_client_pool_network_request()
	if not is_instance_valid(drone):
		return
		
	rpc_unreliable_id(Network.PLAYER_HOST_ID, "_move_drone", drone.get_path(), command)
	
################################################################
# drone event handler
func on_drone_dead(_entity):
	.on_drone_dead(_entity)
	
	if _entity != drone:
		return
		
	if not _entity.is_dead():
		return
		
	respawn_delay_timer.start()
	yield(respawn_delay_timer, "timeout")
		
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
