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
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	_ui.update_player_ammo_bar(_entity.turret_ammo, _entity.turret_max_ammo)
	
	
func on_drone_respawn_ready(_entity :BaseHull):
	.on_drone_respawn_ready(_entity)
	
	# respawn feature for bot only
	if _entity == drone:
		return
		
	respawn_bot_drone(_entity.get_path())
	
	
func on_drone_turret_ammo_update(_turret :BaseTurret, _ammo_left :int, _max_ammo :int):
	.on_drone_turret_ammo_update(_turret, _ammo_left, _max_ammo)
		
	if _turret != drone.get_turret():
		return
		
	_ui.update_player_ammo_bar(_ammo_left, _max_ammo)
	
func on_drone_turret_resupply(_turret :BaseTurret, _ammo_added :int):
	.on_drone_turret_resupply(_turret, _ammo_added)
		
	if _turret != drone.get_turret():
		return
		
	_ui.update_player_ammo_bar(_turret.ammo, _turret.max_ammo)
	
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
	_ui.update_scoreboard(_entity.player.player_id, 0, 1, _entity.player.player_team)
	_ui.update_scoreboard(_hit_by.player_id, 1, 0, _entity.player.player_team)
	
	if _entity in _bots:
		_entity.start_respawn_delay(Global.mp_game_data["respawn_time"])
		return
	
	if _entity != drone:
		return
		
	if not _entity.is_dead():
		return
		
	_ui.update_player_hp_bar(_entity.player.player_name, 0, _entity.max_hp)
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
		
	var bot :BaseHull = _bots[bot_command_cicle]
	if bot.is_dead():
		return
	
	var targets = []
	for i in _all:
		if not i.is_dead():
			targets.append(i)
		
	randomize()
	targets.shuffle()
	
	var target_pos = targets[rand_range(0, targets.size() - 1)].global_transform.origin
	var point = Vector3(target_pos.x, target_pos.y, target_pos.z)
	point.z += rand_range(-6, 6)
	point.x += rand_range(-6, 6) 
	var waypoint = point
		
	var chance_to_get_item = randf() < 0.80 # 80%
	var chance_to_go_somewhere = randf() < 0.40 # 40%
	var is_bot_hp_low = bot.hp < bot.max_hp * 0.70
	var is_bot_ammo_low = bot.get_turret().ammo < bot.get_turret().max_ammo * 0.70
	var is_item_spawn = _item_holder.get_child_count() > 0
		
	# bot go for item
	if chance_to_get_item and (is_bot_ammo_low or is_bot_hp_low) and is_item_spawn:
		var items = _item_holder.get_children()
		var item = items[rand_range(0, items.size() - 1)]
		
		if is_instance_valid(items):
			waypoint = item.global_transform.origin
		
	# bot go somewhere nice
	elif chance_to_go_somewhere:
		waypoint = _map.get_rand_pos()
		
	bot.waypoint = waypoint
	
	
func respawn_bot_drone(drone :NodePath):
	.respawn_drone(drone)
	
func _on_ammo_item_spawner_timer_timeout():
	rpc("spawn_ammo_item", _map.get_rand_pos())
	
func _on_health_item_spawner_timer_timeout():
	rpc("spawn_healing_item", _map.get_rand_pos())










