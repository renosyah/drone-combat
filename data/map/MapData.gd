extends BaseData
class_name MapData

const MAPS : Array = [
	{
		"map_id" : "m-1",
		"map_name" : "Savana",
		"map_icon" : "res://assets/ui/choose-map/grass.png",
		"scene" : "res://map/map_0/map_0.tscn"
	},
		{
		"map_id" : "m-2",
		"map_name" : "Desert",
		"map_icon" : "res://assets/ui/choose-map/dirt.png",
		"scene" : "res://map/map_1/map_1.tscn"
	},
		{
		"map_id" : "m-3",
		"map_name" : "Blizzard",
		"map_icon" : "res://assets/ui/choose-map/snow.png",
		"scene" : "res://map/map_2/map_2.tscn"
	}
]

export var map_id :String = ""
export var map_name :String = ""
export var map_icon :String = ""
export var scene :String = ""

func from_dictionary(data : Dictionary):
	if data.empty():
		return
		
	map_id = data["map_id"]
	map_name = data["map_name"]
	map_icon = data["map_icon"]
	scene = data["scene"]
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["map_id"] = map_id
	data["map_name"] = map_name
	data["map_icon"] = map_icon
	data["scene"] = scene
	return data
	
