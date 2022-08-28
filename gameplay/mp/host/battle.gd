extends BattleMp

var drone : BaseHull

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	Global.on_host_game_session_ready()
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	if not is_instance_valid(drone):
		return
		
	move_drone(drone.get_path() , output)
	
func move_drone(_target : NodePath, _input : Vector2):
	.move_drone(_target, _input)
	._move_drone(_target, _input)
	
func _process(delta):
	if not is_instance_valid(drone):
		return
	
	_camera.translation = drone.global_transform.origin
	

