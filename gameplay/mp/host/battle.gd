extends BattleMp

var drone :BaseHull
var drone_to_follow :BaseHull
var respawn_cicle_index = 0
var bot_command_cicle = 0

func _ready():
	.load_map_stuff()
	drone = spawn_drones_and_get_drone_owned_by(Global.player)
	.set_minimap_player_objects(drone.player)
	_set_respawn_cicle_index(_all.find(drone,0))
	
	_ui.update_player_hp_bar(drone.player.player_name, drone.hp, drone.max_hp, false)
	_ui.update_player_ammo_bar(drone.turret_ammo, drone.turret_max_ammo, false)
	
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
func on_drone_respawn(_entity :BaseHull):
	.on_drone_respawn(_entity)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp, false)
	_ui.update_player_ammo_bar(_entity.turret_ammo, _entity.turret_max_ammo, false)
	
func on_drone_turret_ammo_update(_turret :BaseTurret, _ammo_left :int, _max_ammo :int):
	.on_drone_turret_ammo_update(_turret, _ammo_left, _max_ammo)
	_ui.update_player_ammo_bar(_ammo_left, _max_ammo)
	
func on_drone_turret_resupply(_entity :BaseTurret, _ammo_added :int):
	.on_drone_turret_resupply(_entity, _ammo_added)
	_ui.update_player_ammo_bar(_entity.ammo, _entity.max_ammo)
	
func on_drone_heal(_entity :BaseEntity, _hp_added :int):
	.on_drone_heal(_entity, _hp_added)
	
	if _entity != drone:
		return
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	
func on_drone_take_damage(_entity :BaseEntity, _damage :int, _hit_by: PlayerData):
	.on_drone_take_damage(_entity, _damage, _hit_by)
	
	if _entity != drone:
		return
		
	_ui.show_hurt()
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
		
	_ui.update_player_hp_bar(_entity.player.player_name, 0, _entity.max_hp)
	
	var _respawn_delay_timer = _create_respawn_time_delay()
		
	_respawn_delay_timer.start()
	yield(_respawn_delay_timer, "timeout")
	_respawn_delay_timer.queue_free()
		
	_ui.show_death_screen()
	
################################################################
# ui event handler
func on_respawn_button_press():
	.on_respawn_button_press()

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
		
	# 70% chance bot go for item
	if randf() < 0.70 and _item_holder.get_child_count() > 0:
		var items = _item_holder.get_children()
		var item = items[rand_range(0, items.size() - 1)]
		
		if is_instance_valid(items):
			waypoint = item.global_transform.origin
		
	if bot.is_dead():
		return
		
	bot.waypoint = waypoint
	
	
func respawn_bot_drone(drone :NodePath):
	var _respawn_delay_timer = _create_respawn_time_delay()
	
	_respawn_delay_timer.start()
	yield(_respawn_delay_timer, "timeout")
	_respawn_delay_timer.queue_free()
	
	.respawn_drone(drone)
	
func _on_ammo_item_spawner_timer_timeout():
	rpc("spawn_ammo_item", _map.get_rand_pos())
	
func _on_health_item_spawner_timer_timeout():
	rpc("spawn_healing_item", _map.get_rand_pos())










