extends BaseData
class_name DroneModuleData

export var module_name:String
export var icon:String
export var scene:String

func parse_from_dictionary(data : Dictionary):
	from_dictionary(data)
	return self
	
func from_dictionary(data : Dictionary):
	module_name = data["module_name"]
	icon = data["icon"]
	scene = data["scene"]
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["module_name"] = module_name
	data["icon"] = icon
	data["scene"] = scene
	return data
	
