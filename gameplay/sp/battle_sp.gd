extends BattleSp

var drone :BaseHull
var bot_command_cicle :int = 0
var mission_status_flag :int = MISSION_ONGOING

# Called when the node enters the scene tree for the first time.
func _ready():
	.load_map_stuff()
	.spawn_bot_drones()
	drone = .spawn_player_drones()
	_all.append_array(_bots)
	_all.append(drone)
	.set_minimap_player_objects(drone.player)
	
	_ui.update_player_hp_bar(drone.player.player_name, drone.hp, drone.max_hp)
	_ui.update_player_ammo_bar(drone.turret_ammo, drone.turret_max_ammo)
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	if not is_instance_valid(drone):
		return
		
	._move_drone(drone.get_path(), output)
	
################################################################
# drone event handler
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
		
	var is_normal = _entity.hp >= (_entity.max_hp * 0.25)
	if is_normal:
		_ui.show_hurt(NO_DAMAGE)
		
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	
func on_drone_take_damage(_entity :BaseEntity, _damage :int, _hit_by: PlayerData):
	.on_drone_take_damage(_entity, _damage, _hit_by)
	
	if _entity != drone:
		return
		
	var is_critical = _entity.hp <= (_entity.max_hp * 0.25) and _entity.hp > 1
	_ui.show_hurt(CRITICAL_DAMAGE if is_critical else DAMAGE)
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	
func on_drone_dead(_entity: BaseEntity, _hit_by: PlayerData):
	.on_drone_dead(_entity, _hit_by)
	
	if _entity != drone:
		return
		
	if not _entity.is_dead():
		return
		
	_ui.show_hurt(NO_DAMAGE)
	_ui.update_player_hp_bar(_entity.player.player_name, 0, _entity.max_hp)
	
	mission_status_flag = MISSION_FAILED
	_ui.show_mission_is_failed()
	
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
	if _bots.empty():
		return
		
	bot_command_cicle += 1
	if bot_command_cicle > _bots.size() - 1:
		bot_command_cicle = 0
		
	var bot :BaseHull = _bots[bot_command_cicle]
	if bot.is_dead():
		return
	
	var targets = []
	for i in _bots:
		if not i.is_dead():
			targets.append(i)
		
	randomize()
	targets.shuffle()
	
	var target_pos = targets[rand_range(0, targets.size())].global_transform.origin
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
		var item = items[rand_range(0, items.size())]
		
		if is_instance_valid(items):
			waypoint = item.global_transform.origin
		
	# bot go somewhere nice
	elif chance_to_go_somewhere:
		waypoint = _map.get_rand_pos()
		
	bot.waypoint = waypoint
	
func _on_ammo_item_spawner_timer_timeout():
	rpc("spawn_ammo_item", _map.get_rand_pos())
	
func _on_health_item_spawner_timer_timeout():
	rpc("spawn_healing_item", _map.get_rand_pos())
	
################################################################
# mission check
func _on_mission_checker_timeout():
	if not mission_status_flag == MISSION_ONGOING:
		return
		
	for i in _enemy:
		if not i.is_dead():
			return
			
	mission_status_flag = MISSION_SUCCESS
	_ui.show_mission_is_success()
	check_unlockable()
	
	
func check_unlockable():
	if not Global.sp_game_data.unlocked_module.module_id.empty():
		Global.update_player_unlocked_modules(Global.sp_game_data.unlocked_module.module_id)
		_ui.show_unlocked_item(Global.sp_game_data.unlocked_module.module_name ,load(Global.sp_game_data.unlocked_module.icon))
		
	if not Global.sp_game_data.unlocked_map.map_id.empty():
		Global.update_player_unlocked_modules(Global.sp_game_data.unlocked_map.map_id)
		_ui.show_unlocked_item(Global.sp_game_data.unlocked_map.map_name, load(Global.sp_game_data.unlocked_map.map_icon))
		
	var next_index = Global.sp_game_data.mission_index + 1
	if next_index > SpMissionData.MISSIONS.size() - 1:
		_ui.show_campaign_finish()
		return
	
	var unlocked_mission : SpMissionData = SpMissionData.new()
	unlocked_mission.from_dictionary(SpMissionData.MISSIONS[Global.sp_game_data.mission_index + 1])
	Global.update_player_unlocked_missions(unlocked_mission.mission_id)
	
	
	
	
	
	
	
	
	
	
	
