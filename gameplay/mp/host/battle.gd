extends BattleMp
	
func _ready():
	Global.on_host_game_session_ready()
	$player1.set_network_master(Network.PLAYER_HOST_ID)
	$player2.set_network_master(Network.PLAYER_HOST_ID)
	$player3.set_network_master(Network.PLAYER_HOST_ID)
	
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	$player1.direction = output if is_pressed else Vector2.ZERO
	
func _process(delta):
	_camera.translation = $player1.global_transform.origin
	
