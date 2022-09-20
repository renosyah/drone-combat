extends BattleMp

var drone :BaseHull
var drone_to_follow :BaseHull
var respawn_cicle_index = 0
var bot_command_cicle = 0
var battle_time_left = 0

onready var _battle_time_loop = $battle_time_loop

func _ready():
	.load_map_stuff()
	drone = spawn_drones_and_get_drone_owned_by(Global.player)
	.set_minimap_player_objects(drone.player)
	_set_respawn_cicle_index(_all.find(drone,0))
	
	_ui.update_player_hp_bar(drone.player.player_name, drone.hp, drone.max_hp)
	_ui.update_player_ammo_bar(drone.turret_ammo, drone.turret_max_ammo)
	
	battle_time_left = Global.mp_game_data["battle_time"]
	_battle_time_loop.start()
	
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
		
	_ui.show_hurt(NO_DAMAGE)
	_ui.update_player_hp_bar(_entity.player.player_name, _entity.hp, _entity.max_hp)
	_ui.update_player_ammo_bar(_entity.turret_ammo, _entity.turret_max_ammo)
	
	
func on_drone_respawn_ready(_entity :BaseHull):
	.on_drone_respawn_ready(_entity)
	
	# respawn feature for bot only
	if _entity == drone:
		return
		
	if battle_time_left <= 0:
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
		
	_ui.show_hurt(NO_DAMAGE)
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
	if _bots.empty() or battle_time_left <= 0:
		return
		
	bot_command_cicle += 1
	if bot_command_cicle > _bots.size() - 1:
		bot_command_cicle = 0
		
	var bot :BaseHull = _bots[bot_command_cicle]
	if bot.is_dead():
		return
		
	var waypoint = _map.get_rand_pos()
		
	var targets = []
	for i in _all:
		if i.is_dead():
			continue
			
		if i.team() == bot.team():
			continue
			
		targets.append(i)
		
		
	if not targets.empty():
		randomize()
		targets.shuffle()
		
		var target_pos = targets[0].global_transform.origin
		var point = Vector3(target_pos.x, target_pos.y, target_pos.z)
		point.z += rand_range(-6, 6)
		point.x += rand_range(-6, 6) 
		waypoint = point
		
	var is_bot_hp_low = bot.hp < bot.max_hp * 0.70
	var is_bot_ammo_low = bot.get_turret().ammo < bot.get_turret().max_ammo * 0.70
	var is_item_spawn = _item_holder.get_child_count() > 0
	
	# bot go for item
	if (is_bot_ammo_low or is_bot_hp_low) and is_item_spawn:
		var items = []
		for item in  _item_holder.get_children():
			if not is_instance_valid(item):
				continue
				
			items.append(item)
			
			
		if not items.empty():
			randomize()
			items.shuffle()
			waypoint = items[0].global_transform.origin
		
	bot.waypoint = waypoint
	
	
func respawn_bot_drone(drone :NodePath):
	.respawn_drone(drone)
	
func _on_ammo_item_spawner_timer_timeout():
	rpc("spawn_ammo_item", _map.get_rand_pos())
	
func _on_health_item_spawner_timer_timeout():
	rpc("spawn_healing_item", _map.get_rand_pos())
	
################################################################
# battle time
func _on_battle_time_loop_timeout():
	battle_time_left -= 1
	rpc_unreliable("_update_battle_time", battle_time_left)
	
	if battle_time_left <= 0:
		battle_time_timeout()
		return 
		
	_battle_time_loop.start()
	
func battle_time_timeout():
	for drone in _all:
		drone.is_dead = true
		drone.get_turret().is_dead = true
		
	rpc("_battle_finish", _ui.get_scores())
	
func update_battle_time(time_left:int):
	.update_battle_time(time_left)
	_ui.update_battle_time(time_left)

func battle_finish(scores :Array):
	.battle_finish(scores)
	_ui.set_scores(scores)









