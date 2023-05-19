extends BaseData
class_name ScoreData

var player_id:String
var player_color:Color
var player_name:String
var player_team:int
var kill_count:int
var death_count:int
var total:int

func get_total() -> int:
	return kill_count - death_count

func from_dictionary(data : Dictionary):
	player_id = data["player_id"]
	player_color = data["player_color"]
	player_name = data["player_name"]
	player_team = data["player_team"]
	kill_count = data["kill_count"]
	death_count = data["death_count"]
	total = data["total"]
	
func to_dictionary() -> Dictionary:
	var data = {}
	data["player_id"] = player_id
	data["player_color"] = player_color
	data["player_name"] = player_name
	data["player_team"] = player_team
	data["kill_count"] = kill_count
	data["death_count"] = death_count
	data["total"] = total
	return data
	
