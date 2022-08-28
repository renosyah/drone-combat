extends KinematicBody
class_name BaseEntity

signal on_ready(_entity)
signal on_dead(_entity)
signal on_take_damage(_entity, _damage)

# vitality
var is_dead = false
var tag : String = "entity"
export var hp : int = 100.0
export var max_hp : int = 100.0

# misc network
onready var _latency = Network.LATENCY
onready var _latency_delay = Network.LATENCY_DELAY
var _network_timmer : Timer = null

############################################################
# multiplayer func
func _network_timmer_timeout():
	if is_dead:
		return
		
	if _is_master():
		rset_unreliable("_puppet_hp", hp)
		
puppet var _puppet_hp : float setget _set_puppet_hp
func _set_puppet_hp(_val :float):
	_puppet_hp = _val
	
	if _is_master():
		return
	
	hp = _puppet_hp
	
remotesync func _take_damage(_damage : int):
	if is_dead:
		return
		
	emit_signal("on_take_damage", self, _damage)
	
remotesync func _dead():
	is_dead = true
	set_process(false)
	
	emit_signal("on_dead", self)
	
remotesync func _reset():
	hp = max_hp
	is_dead = false
	
	set_process(true)
	
	emit_signal("on_ready", self)
	
############################################################
func _ready():
	if not _network_timmer:
		_network_timmer = Timer.new()
		_network_timmer.wait_time = _latency_delay
		_network_timmer.connect("timeout", self , "_network_timmer_timeout")
		_network_timmer.autostart = true
		add_child(_network_timmer)
		
	emit_signal("on_ready", self)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	moving(delta)
	
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
		
func take_damage(_damage : int):
	if not _is_master():
		return
		
	hp -= _damage
	
	if is_dead:
		return
		
	if hp < 1:
		dead()
		
	rpc_unreliable("_take_damage", _damage)
	
func dead():
	if not _is_master():
		return
		
	rpc("_dead")
	
func reset():
	if not _is_master():
		return
		
	rpc("_reset")
	
############################################################
func is_dead() -> bool:
	return is_dead
	
############################################################
# multiplayer func
func _is_master() -> bool:
	if not get_tree().network_peer:
		return false
		
	if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		return false
		
	if not is_network_master():
		return false
		
	return true
	
