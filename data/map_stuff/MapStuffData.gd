extends BaseData
class_name MapStuffData

export var mesh_scene = ""
export var translation : Vector3 = Vector3.ZERO

func from_dictionary(data : Dictionary):
	mesh_scene = data["mesh_scene"]
	translation = data["translation"]
	
func to_dictionary() -> Dictionary :
	var data = {}
	data["mesh_scene"] = mesh_scene
	data["translation"] = translation
	return data
	
