extends BattleMp

var command : Vector2
var drone : BaseHull
var drone_to_follow :BaseHull
var respawn_cicle_index = 0

func _ready():
	drone = spawn_drones_and_get_drone_owned_by(Global.player)
	.set_minimap_player_objects(drone.player)
	_set_respawn_cicle_index(_all.find(drone,0))
	.init_client()
	.load_map_stuff()
	
	_ui.update_player_hp_bar(drone.player.player_name, drone.hp, drone.max_hp)
	_ui.update_player_ammo_bar(drone.turret_ammo, drone.turret_max_ammo)
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	command = output
	
func on_client_pool_network_request():
	.on_client_pool_network_request()
	if not is_instance_valid(drone):
		return
		
	if not .is_network_on():
		return

	rpc_unreliable_id(Network.PLAYER_HOST_ID, "_move_drone", drone.get_path(), command)
	
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
# battle time
func update_battle_time(time_left:int):
	.update_battle_time(time_left)
	_ui.update_battle_time(time_left)
	
func battle_finish(scores :Array):
	.battle_finish(scores)
	_ui.set_scores(scores)

