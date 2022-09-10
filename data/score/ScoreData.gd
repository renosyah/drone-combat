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
