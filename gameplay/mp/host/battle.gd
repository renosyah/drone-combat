extends BattleMp

var drone : BaseHull

func _ready():
	drone = spawn_drones_and_get_dronw_owned_by(Global.player.player_id)
	_ui.update_player_hp_bar(drone.player_name, drone.hp, drone.max_hp)
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
func on_drone_ready(_entity):
	.on_drone_ready(_entity)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player_name, _entity.hp, _entity.max_hp)
	
	
func on_drone_take_damage(_entity, _damage):
	.on_drone_take_damage(_entity, _damage)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player_name, _entity.hp, _entity.max_hp)
	
func on_drone_dead(_entity):
	.on_drone_dead(_entity)
	
	if _entity in _bots:
		respawn_bot_drone(_entity.get_path())
		return
	
	if _entity != drone:
		return
		
	if not _entity.is_dead():
		return
		
	var _respawn_delay_timer = _create_respawn_time_delay()
		
	_respawn_delay_timer.start()
	yield(_respawn_delay_timer, "timeout")
	_respawn_delay_timer.queue_free()
		
		
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
		
	if not is_instance_valid(_camera):
		return
	
	_camera.translation = drone.global_transform.origin
	_camera.translation.y = 0.0
	
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
	
func respawn_bot_drone(drone : NodePath):
	var _respawn_delay_timer = _create_respawn_time_delay()
	
	_respawn_delay_timer.start()
	yield(_respawn_delay_timer, "timeout")
	_respawn_delay_timer.queue_free()
	
	.respawn_drone(drone)
	







