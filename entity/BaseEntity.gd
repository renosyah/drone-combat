extends KinematicBody
class_name BaseEntity

signal on_ready(_entity)
signal on_dead(_entity, _killed_by)
signal on_take_damage(_entity, _damage, _hit_by)

# identity owner
var player :PlayerData

# vitality
var is_dead = false
var hit_by_player :PlayerData = PlayerData.new()
var tag : String = "entity"
export var hp : int = 100.0
export var max_hp : int = 100.0

# misc network
var _network_timmer : Timer

############################################################
# multiplayer func
func _network_timmer_timeout():
	if is_dead:
		return
		
	if not _is_network_running():
		return
		
	if not _is_master():
		return
		
	rset_unreliable("_puppet_hp", hp)
	
	
puppet var _puppet_hp : float setget _set_puppet_hp
func _set_puppet_hp(_val :float):
	_puppet_hp = _val
	
	if _is_master():
		return
	
	hp = _puppet_hp
	
remotesync func _take_damage(_damage : int, _hit_by :Dictionary):
	if is_dead:
		return
		
	hit_by_player.from_dictionary(_hit_by)
	emit_signal("on_take_damage", self, _damage, hit_by_player)
	
remotesync func _dead():
	is_dead = true
	set_process(false)
	
	emit_signal("on_dead", self, hit_by_player)
	
remotesync func _reset():
	hp = max_hp
	is_dead = false
	
	set_process(true)
	
	emit_signal("on_ready", self)
	
############################################################
func _ready():
	emit_signal("on_ready", self)
	
	if not _is_network_running():
		return
	
	if not _is_master():
		return
	
	var _timer = Timer.new()
	_timer.wait_time = Network.LATENCY_DELAY
	_timer.connect("timeout", self , "_network_timmer_timeout")
	_timer.autostart = true
	add_child(_timer)
	_network_timmer = _timer
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	moving(delta)
	
	if not _is_network_running():
		return
	
	if _is_master():
		master_moving(delta)
	else:
		puppet_moving(delta)
	
func master_moving(delta):
	pass
	
func moving(_delta):
	pass
	
func puppet_moving(_delta):
	pass
		
func take_damage(_damage : int, hit_by_player : PlayerData):
	if not _is_master():
		return
		
	hp -= _damage
	
	if is_dead:
		return
		
	if hp < 1:
		dead()
		
	rpc_unreliable("_take_damage", _damage, hit_by_player.to_dictionary())
	
func dead():
	if not _is_master():
		return
		
	rpc("_dead")
	
func reset():
	if not _is_master():
		return
		
	rpc("_reset")
	
############################################################
func team():
	if not player:
		return ""
		
	return player.player_team
	
func is_dead() -> bool:
	return is_dead
	
############################################################
# multiplayer func
func _is_network_running():
	if not get_tree().network_peer:
		return false
		
	if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		return false
		
	return true
	
func _is_master() -> bool:
	if not get_tree().network_peer:
		return false
		
	if not is_network_master():
		return false
		
	return true
	
