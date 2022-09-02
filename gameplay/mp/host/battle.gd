extends BattleMp

var drone :BaseHull
var drone_to_follow :BaseHull
var respawn_cicle_index = 0
var bot_command_cicle = 0

func _ready():
	drone = spawn_drones_and_get_drone_owned_by(Global.player.player_id)
	_set_respawn_cicle_index(_all.find(drone,0))
	_ui.update_player_hp_bar(drone.player.player_name, drone.hp, drone.max_hp)
	.load_map_stuff()
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	if not is_instance_valid(drone):
		return
		
	._move_drone(drone.get_path(), output)
	
func _on_spectate_previous():
	_set_respawn_cicle_index(respawn_cicle_index + 1)
	
func _on_spectate_next():
	_set_respawn_cicle_index(respawn_cicle_index - 1)
	
func _set_respawn_cicle_index(val:int):
	respawn_cicle_index = val
	
	if respawn_cicle_index > _all.size() - 1:
		respawn_cicle_index = 0
		
	elif respawn_cicle_index < 0:
		respawn_cicle_index = _all.size() - 1
		
	drone_to_follow = _all[respawn_cicle_index]
	
################################################################
# drone event handler
func on_drone_ready(_entity :BaseEntity):
	.on_drone_ready(_entity)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	
	
func on_drone_take_damage(_entity :BaseEntity, _damage :int, _hit_by: PlayerData):
	.on_drone_take_damage(_entity, _damage, _hit_by)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	
func on_drone_dead(_entity: BaseEntity, _hit_by: PlayerData):
	.on_drone_dead(_entity, _hit_by)
	
	_ui.display_event_message(_hit_by.player_name + " Kill " + _entity.player.player_name)
	_ui.update_scoreboard(_entity.player.player_id, 0, 1)
	_ui.update_scoreboard(_hit_by.player_id, 1, 0)
	
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
		
	_set_respawn_cicle_index(_all.find(drone,0))
	.respawn_drone(drone.get_path())
	
################################################################
# process
func _process(delta):
	if not is_instance_valid(drone_to_follow):
		return
		
	if not is_instance_valid(_camera):
		return
	
	_camera.translation = drone_to_follow.global_transform.origin
	_camera.translation.y = 0.0
	
################################################################
# bot action
func _on_bot_action_timer_timeout():
	if _bots.empty():
		return
		
	bot_command_cicle += 1
	if bot_command_cicle > _bots.size() - 1:
		bot_command_cicle = 0
	
	var bot = _bots[bot_command_cicle]
	var waypoint = _map.get_rand_pos()
	
	if bot.is_dead():
		return
		
	if randf() > 0.5:
		var player = _players[rand_range(0, _players.size() - 1)]
		waypoint = player.translation
		
	bot.waypoint = waypoint
	
func respawn_bot_drone(drone :NodePath):
	var _respawn_delay_timer = _create_respawn_time_delay()
	
	_respawn_delay_timer.start()
	yield(_respawn_delay_timer, "timeout")
	_respawn_delay_timer.queue_free()
	
	.respawn_drone(drone)
	







