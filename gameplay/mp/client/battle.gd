extends BattleMp

var command : Vector2
var drone : BaseHull

func _ready():
	drone = spawn_drones_and_get_drone_owned_by(Global.player.player_id)
	_ui.update_player_hp_bar(drone.player_name, drone.hp, drone.max_hp)
	.init_client()
	.load_map_stuff()
	
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
	
	_ui.display_event_message(_entity.player.player_name + " Killed by " + _hit_by.player_name)
	
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
	
