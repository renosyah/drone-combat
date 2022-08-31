extends BattleMp

var drone : BaseHull
onready var respawn_delay_timer : Timer = $respawn_delay_timer

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	.load_map_stuff()
	
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
	
################################################################
# bot action
func _on_bot_action_timer_timeout():
	var bot = _bots[rand_range(0, _bots.size() - 1)]
	var waypoint = _map.get_rand_pos()
	
	if bot.is_dead():
		return
		
	if randf() > 0.5:
		var player = _players[rand_range(0, _players.size() - 1)]
		waypoint = player.translation
		
	bot.waypoint = waypoint
	
func _on_bot_checker_timer_timeout():
	for bot in _bots:
		if bot.is_dead():
			.respawn_drone(bot.get_path())










