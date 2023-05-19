extends BaseData
class_name DroneModuleData

export var module_id:String
export var module_name:String
export var icon:String
export var scene:String
export var infos:Array

export var modifier:Dictionary

func parse_from_dictionary(data : Dictionary):
	from_dictionary(data)
	return self
	
func from_dictionary(data : Dictionary):
	if data.empty():
		return
		
	module_id = data["module_id"]
	module_name = data["module_name"]
	icon = data["icon"]
	scene = data["scene"]
	infos = data["infos"].duplicate()
	modifier = data["modifier"].duplicate()
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["module_id"] = module_id
	data["module_name"] = module_name
	data["icon"] = icon
	data["scene"] = scene
	data["infos"] = infos
	data["modifier"] = modifier
	return data
	
