extends BaseData
class_name SpMissionData

export var mission_id :String = ""
export var mission_index :int =  0
export var mission_name :String =  ""
export var mission_objective :String =  ""
export var mission_bot_drones :Array = []
var mission_map :MapData = MapData.new()
var unlocked_module :DroneModuleData = DroneModuleData.new()
var unlocked_map :MapData = MapData.new()

func from_dictionary(data : Dictionary):
	mission_id = data["mission_id"]
	mission_index = data["mission_index"]
	mission_name = data["mission_name"]
	mission_objective = data["mission_objective"]
	mission_bot_drones = data["mission_bot_drones"]
	mission_map = MapData.new()
	mission_map.from_dictionary(data["mission_map"])
	unlocked_module = DroneModuleData.new()
	unlocked_module.from_dictionary(data["unlocked_module"])
	unlocked_map = MapData.new()
	unlocked_map.from_dictionary(data["unlocked_map"])
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["mission_id"] = mission_id
	data["mission_index"] = mission_index
	data["mission_name"] = mission_name
	data["mission_objective"] = mission_objective
	data["mission_bot_drones"] = mission_bot_drones
	data["mission_map"] = mission_map.to_dictionary()
	data["unlocked_module"] = unlocked_module.to_dictionary()
	data["unlocked_map"] = unlocked_map.to_dictionary()
	return data
	
