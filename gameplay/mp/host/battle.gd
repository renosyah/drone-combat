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
	
func _on_player_on_dead(_entity):
	var msg = preload("res://assets/ui/floating-message-3d/floating_message_3d.tscn").instance()
	add_child(msg)
	msg.translation = _entity.global_transform.origin
	msg.set_color(Color.white)
	msg.set_message("tank disabled" if _entity.tag == "hull" else "turret disabled")
	
func _on_Timer_timeout():
	$player2.waypoint_mode = true
	$player2.waypoint = get_rand_pos()
	
	$player3.waypoint_mode = true
	$player3.waypoint = get_rand_pos()
	
func get_rand_pos() -> Vector3:
	var angle := rand_range(0, TAU)
	var distance := rand_range(15, 35)
	var posv2 = polar2cartesian(distance, angle)
	var posv3 = _map.global_transform.origin + Vector3(posv2.x, 0.0, posv2.y)
	posv3.y = 0
	return posv3
