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
	
################################################################
# drone control
func on_joystick_input(output : Vector2, is_pressed : bool):
	.on_joystick_input(output, is_pressed)
	command = output
	
func on_client_pool_network_request():
	.on_client_pool_network_request()
	if not is_instance_valid(drone):
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
	
