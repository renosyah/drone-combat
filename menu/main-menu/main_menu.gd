extends Node

var drone : BaseHull

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player_drone()
	
	if Admob.get_is_banner_loaded():
		Admob.show_banner()
	else:
		Admob.connect("banner_loaded", self, "_banner_loaded")
		Admob.load_banner()
	
func _banner_loaded():
	Admob.show_banner()
	
func spawn_player_drone():
	if is_instance_valid(drone):
		drone.queue_free()
		
	Global.load_player_drone_data()
	drone = Global.player_drone_data.spawn(Global.player, self, Vector3.ZERO)
	
	
func _on_main_menu_on_drone_data_change():
	spawn_player_drone()
