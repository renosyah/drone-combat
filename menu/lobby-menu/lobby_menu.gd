extends Node

onready var pos = [
	Vector3(-4,0,0),
	Vector3.ZERO,
	Vector3(4,0,0),
	Vector3(8,0,0),
]

onready var map = $map_0
onready var holder = $holder
onready var ui = $ui
onready var camera = $cameraPivot
onready var tween = $Tween

func _ready():
	set_map()
	ui.connect("spawn_joined_player", self, "_on_ui_spawn_joined_player")
	ui.connect("on_cicle_between_player", self, "_on_cicle_between_player")
	_on_ui_spawn_joined_player(0, ui.player_joined)
	
func set_map():
	var map_data :MapData = MapData.new()
	map_data.from_dictionary(Global.mp_game_data["map"])
	var new_map = load(map_data.scene).instance()
	remove_child(map)
	add_child(new_map)
	new_map.translation = map.translation
	
func _on_ui_spawn_joined_player(index :int, players :Array):
	for i in holder.get_children():
		holder.remove_child(i)
		i.queue_free()
		
	var idx = 0
	for player in players:
		spawn_player_drone(idx, player)
		idx += 1
		
	_on_cicle_between_player(index)
	
func spawn_player_drone(idx :int, data :Dictionary):
	var player :PlayerData = PlayerData.new()
	player.from_dictionary(data)
	
	var drone :DroneData = DroneData.new()
	drone.from_dictionary(data["drone_data"])
	
	var spawned :BaseHull = drone.spawn(player, holder, pos[idx])
	spawned.get_turret().is_dead = true
	spawned.is_dead = true
	
func _on_cicle_between_player(index :int):
	tween.interpolate_property(camera, "translation",camera.translation,pos[index],0.5)
	tween.start()
	
	
