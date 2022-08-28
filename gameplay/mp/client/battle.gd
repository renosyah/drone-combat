extends BattleMp

var command : Vector2
var drone : BaseHull

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	command = output
	
func move_drone(_target : NodePath, _input : Vector2):
	.move_drone(_target, _input)
	rpc_unreliable_id(Network.PLAYER_HOST_ID, "_move_drone", _target, _input)
	
func on_client_pool_network_request():
	.on_client_pool_network_request()
	if not is_instance_valid(drone):
		return
		
	move_drone(drone.get_path() , command)
	
func _process(delta):
	if not is_instance_valid(drone):
		return
	
	_camera.translation = drone.global_transform.origin
	
